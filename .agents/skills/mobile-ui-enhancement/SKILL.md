---
name: mobile-ui-enhancement
description: This skill enables an AI agent to analyze, evaluate, and propose improvements for mobile user interface (UI) designs. It moves beyond merely making designs "pretty" by focusing on clarity, usability, hierarchy, accessibility, and delightful interaction. Use it when designing or reviewing mobile screens.
---

# Mobile UI Enhancement Framework

## Description
This skill enables an AI agent to analyze, evaluate, and propose improvements for mobile user interface (UI) designs. It moves beyond merely making designs "pretty" by focusing on clarity, usability, hierarchy, accessibility, and delightful interaction.

The framework acts as a mental checklist to apply to any mobile screen being designed or reviewed.

---

## The Mobile UI Refinement Framework

The framework is broken down into four essential pillars for evaluating and improving a design.

### Pillar 1: Clarity & Hierarchy (The Foundation)
Before adding colors or shadows, the structure must be sound. The user should never have to guess what is most important.

* **The "One Primary Action" Rule**
    * *Concept:* Every screen should have one clear, primary goal for the user (e.g., "Buy Now," "Post," "Read").
    * **Enhancement Action:** Identify the primary action. Make that element the most prominent through size, color, and central placement. All other actions (secondary, tertiary) should be visually subordinate (e.g., outline buttons, smaller text links).

* **Visual Hierarchy through Typography**
    * *Concept:* Use text size, weight, and color to guide the user's eye through the content in order of importance.
    * **Enhancement Action:** Establish a strict typographic scale (e.g., H1 for titles, H2 for section headers, Body for content, Caption for labels). Ensure a clear visual distinction exists between each level to avoid confusion.

* **The Power of Whitespace (Negative Space)**
    * *Concept:* Whitespace is an active design tool that creates grouping and reduces cognitive load.
    * **Enhancement Action:** Don't fear gaps. Increase padding inside containers and margins between elements. Group related items (like a photo + title + price) by giving them smaller internal spacing and larger external spacing to separate them from neighboring groups.

### Pillar 2: Aesthetics & Polish (The Visuals)
This pillar addresses creating a pleasing, professional look that builds user trust.

* **Color Palette Discipline**
    * *Concept:* A chaotic or undefined color scheme feels unprofessional.
    * **Enhancement Action:** Stick to a defined palette: 1 Primary color (main actions), 1 Secondary color (accents), Neutrals (black, white, grays for text/backgrounds), and Semantic colors (red for error, green for success). Use the **60-30-10 rule** as a starting point: 60% neutral, 30% brand color, 10% accent color.

* **Consistent Iconography**
    * *Concept:* Icons are a visual language; mixing styles confuses the user.
    * **Enhancement Action:** Use a single, cohesive icon set (e.g., Material Icons, SF Symbols). Ensure all icons share the same stroke width, style (filled vs. outlined), and corner radius.

* **Borders, Shadows, and Depth**
    * *Concept:* These elements add realism and define layers, but must be used sparingly.
    * **Enhancement Action:** Avoid harsh, dark shadows; use soft, multi-layered shadows for subtle depth. Use subtle grays for borders instead of stark black. Use elevation sparingly to indicate elements lifted temporarily above content (e.g., modals, FABs).

### Pillar 3: Interaction & Feedback (The Feel)
Mobile is a tactile medium. A good UI acknowledges touch and guides the user.

* **Fitt's Law & Touch Targets**
    * *Concept:* Fingers are clumsy compared to cursors. Interactive areas must be large enough to tap easily.
    * **Enhancement Action:** Ensure all interactive elements have a minimum touch target size of **44x44 points (iOS) or 48x48 dp (Android)**. The visible icon can be smaller, but the invisible tappable area must meet this requirement.

* **Visual Feedback States**
    * *Concept:* The user needs immediate confirmation that their action was registered.
    * **Enhancement Action:** Every interactive element must have distinct states: **Default, Pressed/Active, and Disabled**. A tap should trigger an instant color change or ripple effect. Disabled elements must look clearly inactive.

* **Micro-interactions**
    * *Concept:* Small, functional animations provide clarity and delight.
    * **Enhancement Action:** Add subtle animations, such as a toggle sliding smoothly, a heart icon filling upon a "like," or a loading spinner appearing within a button after a tap.

### Pillar 4: Accessibility (Inclusive Design)
An enhanced UI must be usable by everyone, including those with visual, auditory, or motor impairments.

* **Color Contrast**
    * *Concept:* Text must be easily readable against its background.
    * **Enhancement Action:** Use contrast checker tools. Aim for a minimum contrast ratio of **4.5:1** for normal text and **3:1** for large text and graphical UI components.

* **Don't Rely on Color Alone**
    * *Concept:* Information must be conveyable to users with color blindness.
    * **Enhancement Action:** Never use color as the only indicator of status. For an error state, do not just turn a border red; add an error icon and a descriptive text message.

---

## The Practitioner's Toolkit (Exercises)

Techniques to evaluate designs and build refinement skills.

### Exercise 1: The "Squint Test" (For Hierarchy)
**Goal:** Evaluate visual dominance and grouping.
1.  Take a step back from the design.
2.  Squint eyes until details blur into blobs of color and shape.
3.  **Analysis:** What pops out first? (It should be the primary action). Are elements logically grouped into single shapes, or is the layout scattered? Use findings to adjust sizing and spacing.

### Exercise 2: The Greyscale Audit (For Contrast & Color Reliance)
**Goal:** Ensure accessibility and clarity without color cues.
1.  Temporarily convert the design to grayscale.
2.  **Analysis:** Can text still be read easily? Can you still determine the state of elements (e.g., success vs. error)? If not, contrast needs increasing, or supporting icons/text must be added.

### Exercise 3: Copywork (Reverse Engineering)
**Goal:** Internalize professional design decisions.
1.  Find a high-quality mobile app screen you admire.
2.  Import a screenshot of it into a design tool.
3.  **Action:** Recreate it pixel-for-pixel.
4.  **Analysis:** While recreating, actively analyze *why* they made specific choices regarding font sizes, exact spacing values, color codes, and icon styles.
