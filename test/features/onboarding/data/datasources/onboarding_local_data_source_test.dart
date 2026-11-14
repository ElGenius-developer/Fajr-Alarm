import 'package:fajr_alarm/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:fajr_alarm/features/onboarding/data/models/onboarding_state_model.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<OnboardingStateModel> {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockBox box;
  late MockFlutterSecureStorage secureStorage;
  late OnboardingLocalDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(const OnboardingStateModel());
  });

  setUp(() {
    box = MockBox();
    secureStorage = MockFlutterSecureStorage();
    dataSource = OnboardingLocalDataSourceImpl(
      stateBox: box,
      secureStorage: secureStorage,
    );
  });

  test('returns default entity when Hive box has no entry', () async {
    when(() => box.get(OnboardingLocalDataSourceImpl.stateKey))
        .thenReturn(null);

    final OnboardingStateEntity result = await dataSource.getOnboardingState();

    expect(result, const OnboardingStateEntity());
  });

  test('saves and reads OnboardingStateEntity via Hive box', () async {
    const OnboardingStateEntity entity = OnboardingStateEntity(
      step: 2,
      cityName: 'Cairo',
      latitude: 30.0444,
      longitude: 31.2357,
      permissionsGranted: true,
    );
    when(() => box.put(OnboardingLocalDataSourceImpl.stateKey, any()))
        .thenAnswer((_) async {});
    when(() => box.get(OnboardingLocalDataSourceImpl.stateKey))
        .thenReturn(OnboardingStateModel.fromEntity(entity));

    await dataSource.saveOnboardingState(entity);
    final OnboardingStateEntity loaded = await dataSource.getOnboardingState();

    expect(loaded, entity);
  });

  test('writes and reads Gemini API key in FlutterSecureStorage', () async {
    when(
      () => secureStorage.write(
        key: OnboardingLocalDataSourceImpl.geminiApiKeyStorageKey,
        value: 'AIzaSecret',
      ),
    ).thenAnswer((_) async {});
    when(
      () => secureStorage.read(
        key: OnboardingLocalDataSourceImpl.geminiApiKeyStorageKey,
      ),
    ).thenAnswer((_) async => 'AIzaSecret');

    await dataSource.saveGeminiKey('AIzaSecret');
    final String? key = await dataSource.getGeminiKey();

    expect(key, 'AIzaSecret');
  });

  test('writes and deletes bathroom barcode in FlutterSecureStorage', () async {
    when(
      () => secureStorage.write(
        key: OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey,
        value: 'BAR-123',
      ),
    ).thenAnswer((_) async {});
    when(
      () => secureStorage.delete(
        key: OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey,
      ),
    ).thenAnswer((_) async {});

    await dataSource.saveBathroomBarcode('  BAR-123  ');
    await dataSource.saveBathroomBarcode(null);
    await dataSource.saveBathroomBarcode('   ');

    verify(
      () => secureStorage.write(
        key: OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey,
        value: 'BAR-123',
      ),
    ).called(1);
    verify(
      () => secureStorage.delete(
        key: OnboardingLocalDataSourceImpl.bathroomBarcodeStorageKey,
      ),
    ).called(2);
  });

  test('OnboardingStateModelAdapter writes and reads all fields via BinaryWriter/BinaryReader', () {
    final OnboardingStateModelAdapter adapter = OnboardingStateModelAdapter();
    expect(adapter.typeId, 30);

    final FakeBinaryWriter writer = FakeBinaryWriter();
    const OnboardingStateModel model = OnboardingStateModel(
      step: 3,
      latitude: 21.3891,
      longitude: 39.8579,
      cityName: 'Makkah',
      permissionsGranted: true,
      privacyConsentAccepted: true,
      apiKeyValidated: true,
      registeredBarcode: '987654321',
      isCompleted: true,
    );

    adapter.write(writer, model);
    final OnboardingStateModel readBack = adapter.read(
      FakeBinaryReader(writer.bytes),
    );

    expect(readBack.toEntity(), model.toEntity());
  });
}

final class FakeBinaryWriter implements BinaryWriter {
  final List<Object?> bytes = <Object?>[];

  @override
  void writeByte(int byte) => bytes.add(byte);

  @override
  void write<T>(T value, {bool withTypeId = true}) => bytes.add(value);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeBinaryReader implements BinaryReader {
  FakeBinaryReader(this._values);

  final List<Object?> _values;
  int _index = 0;

  @override
  int readByte() => _values[_index++]! as int;

  @override
  dynamic read([int? typeId]) => _values[_index++];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
