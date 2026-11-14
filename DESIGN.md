# Anti-Slop Design System (ASDS)

**Platform:** `ariffzakaria.dev` / `lab.ariffzakaria.dev`  
**Engineer:** Muhammad 'Ariff Bin Mohd Zakaria  
**Focus:** Software Engineering (Full-Stack/Backend), Cloud/DevOps & Site Reliability Engineering (SRE)  
**Standard:** Production-Grade Dark Mode Bento Grid · Strict Anti-AI-Slop Architecture

---

## 1. Core Principles

1. **Information Density with Restraint:** Every pixel carries operational or architectural signal. No decorative filler cards, no fake metrics, no vanity counters.
2. **Deterministic Aesthetics:** Interfaces are engineered from a fixed 8px spatial grid, high-contrast monochrome values, and calibrated functional status accents.
3. **Zero AI Slop:** No text emojis anywhere. No neon purple/violet gradients. No fuzzy ambient glow blobs. No AI marketing jargon ("seamless", "unlock", "revolutionize", "testament", "pivotal", "tapestry"). All icons are authored 1.5px stroke SVGs.
4. **Mechanical Polish (Emil Kowalski Rules):** Micro-interactions use precise single-property CSS transitions governed by `cubic-bezier(0.23, 1, 0.32, 1)`. Active states compress slightly (`scale(0.98)`). Reduced-motion preferences are strictly respected.
5. **Themed Browser Surfaces:** Scrollbars, text selections (`::selection`), focus rings, and numeric data (`tabular-nums`) are intentionally styled to match the dark canvas.

---

## 2. Color Palette & Functional Tokens

All color decisions serve functional categorization and contrast compliance (WCAG AAA for body text on dark canvas).

### 2.1 Surfaces & Canvas

| Token Name | Hex / RGBA | Purpose | Contrast Ratio |
| :--- | :--- | :--- | :--- |
| `canvas-obsidian` | `#090C10` | Primary viewport background | Base |
| `surface-bento` | `#11161F` | Bento card and container background | 1.15:1 vs canvas |
| `surface-bento-sub` | `#161D29` | Sub-cards, table headers, code containers | 1.3:1 vs canvas |
| `surface-glass` | `rgba(9, 12, 16, 0.82)` | Sticky command header backdrop with 12px blur | Translucent |
| `border-hairline` | `rgba(255, 255, 255, 0.08)` | Default card and divider hairline borders | 1px solid |
| `border-hover` | `rgba(255, 255, 255, 0.16)` | Card border highlight on fine-pointer hover | 1px solid |
| `border-active` | `rgba(255, 255, 255, 0.24)` | Active focus / tab selection borders | 1px solid |

### 2.2 Text & Typography Hierarchy

| Level | Value | Weight | Usage |
| :--- | :--- | :--- | :--- |
| **Primary Text** | `#F9FAFB` | 600 / 700 / 500 | Headings, card titles, primary metric figures |
| **Secondary Text** | `#9CA3AF` | 400 / 500 | Explanatory copy, architecture specs, labels |
| **Tertiary / Muted** | `#6B7280` | 400 / Mono | Metadata, port allocations, socket bindings, timestamps |

### 2.3 Functional Status & Metric Accents

| System Token | Hex | Badge Fill | Purpose |
| :--- | :--- | :--- | :--- |
| **Emerald Status** | `#10B981` | `rgba(16, 185, 129, 0.10)` | Live containers, healthy daemons, passing tests |
| **ChargeTrail Teal** | `#00897B` | `rgba(0, 137, 123, 0.12)` | Flagship 1 brand accent, storage metrics, primary CTAs |
| **Sky Telemetry** | `#0EA5E9` | `rgba(14, 165, 233, 0.10)` | CPU clock/TLP metrics, kernel details, network info |
| **Amber Warning** | `#F59E0B` | `rgba(245, 158, 11, 0.10)` | Thermal warm states (56°C–64°C), transitional loads |
| **Rose Critical** | `#F43F5E` | `rgba(244, 63, 94, 0.12)` | Thermal alert (≥65°C Dell SMM fan trip), errors |

---

## 3. Typography Rules

### 3.1 Font Families

- **Primary Sans:** `Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`
  - Body copy, narrative architecture briefs, headings, standard button text.
  - Headings: `font-semibold` (600) or `font-bold` (700) with `-0.025em` tracking (`tracking-tight`).
  - Leading: `leading-snug` on headings, `leading-relaxed` on body text.
- **Precision Monospace:** `JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace`
  - Bound to: all hardware telemetry readouts, IP addresses, port maps, Docker container IDs, formulas, test counts, runtime timestamps, and live status pills.
  - Figures enforce `font-feature-settings: "tnum" 1` (`tabular-nums`) to eliminate layout jitter during 15s polling cycles.

### 3.2 Scale & Hierarchy

| Role | Font Family | Size | Weight | Tracking |
| :--- | :--- | :--- | :--- | :--- |
| Page Identity | Inter | 1.875rem (30px) | 700 | `-0.025em` |
| Section Header | Inter | 1.25rem (20px) | 700 | `-0.02em` |
| Bento Card Title | Inter | 1.125rem (18px) | 600 | `-0.015em` |
| Metric Display | JetBrains Mono | 1.75rem – 2.0rem | 700 | `-0.03em` |
| Body Copy | Inter | 0.875rem (14px) | 400 | Normal |
| Telemetry / Specs | JetBrains Mono | 0.75rem – 0.8125rem | 500 | `0.02em` |
| Micro-Badges | JetBrains Mono | 0.6875rem (11px) | 600 | `0.05em` (uppercase) |

---

## 4. Strict 8px Spatial Scale & Layout

All padding, margins, gaps, and dimensions strictly adhere to multi-unit increments of 8px (with 4px allowed exclusively for compact badges and icon gaps).

- **Max Container Width:** `1200px` (`max-w-[1200px]`), centered via `mx-auto`.
- **Viewport Horizontal Margins:**
  - Mobile (< 768px): `24px` (`px-6`)
  - Desktop (≥ 1024px): `48px` (`px-12`)
- **Bento Card Padding:**
  - Primary Spotlight Cards: `32px` (`p-8`)
  - Standard Bento Grid Cards: `24px` (`p-6`)
  - Sub-Cards / Proof Metrics: `16px` to `20px` (`p-4` to `p-5`)
- **Grid Gaps:**
  - Primary Bento Rows: `24px` (`gap-6`)
  - Dense Metric Sub-Grids: `16px` (`gap-4`)
- **Border Radii:**
  - Bento Container Cards: `16px` (`rounded-2xl`)
  - Interactive Action Buttons / Tabs: `8px` (`rounded-lg`) or `10px` (`rounded-[10px]`)
  - Status Pills & Dots: `9999px` (`rounded-full`)

---

## 5. Motion & Micro-Interactions (Emil Kowalski Rules)

1. **Explicit Property Transitions:**
   - **Rule:** Never apply `transition: all`.
   - **Allowed:** Target exact computed properties: `transition: color 180ms var(--ease-out), background-color 180ms var(--ease-out), border-color 180ms var(--ease-out), transform 180ms var(--ease-out), opacity 180ms var(--ease-out)`.
2. **Custom Easing:**
   - Use custom cubic bezier: `cubic-bezier(0.23, 1, 0.32, 1)` (strong ease-out for immediate mechanical feedback).
   - Interaction duration limit: `180ms` for all interactive clicks, tab selections, and hover state transitions.
3. **Press Feedback:**
   - All interactive controls (buttons, tabs, clickable project cards) compress to `transform: scale(0.98)` on `:active`.
4. **Natural Enter States:**
   - Elements never scale up from `scale(0)`. Entrance animations start at `scale(0.98)` with `opacity: 0`.
5. **Accessibility (`prefers-reduced-motion`):**
   - When `prefers-reduced-motion: reduce` is enabled, all scale and translation transforms are suppressed, leaving instantaneous or gentle opacity-only crossfades.

```css
:root {
  --ease-out-snappy: cubic-bezier(0.23, 1, 0.32, 1);
  --duration-interaction: 180ms;
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
    transform: none !important;
  }
}
```

---

## 6. Anti-AI-Slop & Humanizer Enforcement

### 6.1 Absolute Visual Bans
- **No Emojis as Icons:** Replace all emoji glyphs (such as rocket, recycle, lightning bolt, shield, whale, mobile phone, monitor, or globe) with crisp 1.5px stroke inline SVGs drawn with geometric precision.
- **No Neon Purple/Magenta Gradients:** No violet hero text gradients, no iridescent drop shadows, no neon cyberpunk halos.
- **No Fuzzy Glow Artifacts:** No large radial blurred blobs floating behind cards. Surfaces derive depth through a single hairline 1px border and discrete tone contrast.
- **No Decorative Eyebrows:** Avoid redundant kicker tags above headers. Let headings directly state the subject.

### 6.2 Writing & Voice Standards
- **Direct Technical Prose:** Write about architecture, concurrency, protocols, packet flow, socket bindings, and measured benchmarks.
- **Banned Chatbot Residue:** Never include "delve", "pivotal", "testament", "tapestry", "seamless", "cutting-edge", "game-changer", "empower", "revolutionize".
- **No Staged Run-Ups:** Avoid phrases like "Let's explore", "Here is what you need to know", or "In today's digital landscape".
- **No "Not X but Y" Contrast Formulas:** State what the engineering solution is and does directly.
- **No Forced Triads:** Do not pad lists with three adjectives or three parallel claims unless the technical reality has exactly three components.
- **No Em Dashes as Crutches:** Use periods, colons, or parentheses for syntactic clarity.

---

## 7. Component Specifications

### 7.1 Sticky Glassmorphic Command Header
- Height: 64px (`h-16`).
- Backdrop: `rgba(9, 12, 16, 0.82)` with `backdrop-filter: blur(12px)`.
- Border bottom: `1px solid rgba(255, 255, 255, 0.08)`.
- Live Status Pill: Emerald breathing dot (`bg-[#10B981]`) with active CSS ring ping, text bound to `{{ telemetry.hostname }} · {{ telemetry.containers_running }} Containers Online`.
- Navigation: Text links with subtle hover transition (`text-[#9CA3AF]` to `text-[#F9FAFB]`).

### 7.2 Hardware Telemetry Bento Row
- 4-column responsive grid (`grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4`).
- Cards bind directly to `/telemetry.json` (`telemetry.hardware`).
- Metric numbers rendered in large JetBrains Mono (`text-2xl` / `text-3xl font-bold`).
- Progress tracks use dark slate groove (`bg-[#1E293B]/60`) with teal/emerald/sky fill bars, replacing default purple hues.
- Thermal card alerts dynamically: Optimal (emerald), Warm (amber), Fan Active (rose).

### 7.3 Flagship 1 Spotlight: ChargeTrail v2
- Visual hierarchy: Large featured Bento container with full hardware screenshot gallery.
- Interactive tab switcher: 4 screens with responsive preview viewport, subtle bezel frame, and 180ms smooth state swap.
- 4 Engineering proof metric sub-cards highlighting:
  1. `$0.00/mo` Commercial API Cost (OSRM, Nominatim, Photon on IPv4 0.0.0.0 socket).
  2. `< 350ms` Route Calculation (vectorized corridor stop optimizer).
  3. `cp = dx·sy - dy·sx` Keep-Left Expressway R&R Scorer (cross-product divider penalty).
  4. `103 / 103` Automated Tests Passing (Pytest + Flutter, SAST audit, PBKDF2-HMAC).

### 7.4 Flagship 2 & 3 Two-Column Bento Grid
- Equal height 2-column grid (`grid-cols-1 lg:grid-cols-2 gap-6`).
- Card A: **OpenRVM Cloud v2.0** — 6 Docker containers, PostgreSQL 16, Redis 7 SETNX concurrency locks, smart waste IoT simulator, split-photo fraud audit.
- Card B: **Bare-Metal Homelab & DevSecOps** — Dell Latitude E6330, Ubuntu 24.04 LTS, static LAN 192.168.1.62, Cloudflare Zero Trust tunnel, Pi-hole v6, Uptime Kuma monitoring, systemd GitHub Actions runner.

### 7.5 Live 12-Container Docker Telemetry Table
- Full tabular representation of `telemetry.containers`.
- Architectural role mapping dictionary containing explicit entries for `chargetrail_web`, `chargetrail_api`, `openrvm_ui`, `openrvm_api`, `openrvm_simulator`, `openrvm_db`, `openrvm_redis`, `openrvm_tunnel`, `openrvm_ngrok`, `nginx-web`, `pihole`, and `uptime-kuma`.
- Status indicators with live emerald pulse for running state and monospace resource stats.

---

## 8. Verification Checklist

- [x] Canvas is `#090C10` and Bento cards are `#11161F`.
- [x] Hairline borders are `1px solid rgba(255, 255, 255, 0.08)`.
- [x] Zero emojis rendered anywhere in markup or copy.
- [x] All icons use crisp 1.5px stroke inline SVGs.
- [x] Headings use Inter with `-0.025em` letter spacing.
- [x] All metrics, ports, and telemetry use JetBrains Mono with tabular numbers.
- [x] Transitions specify exact properties with 180ms `cubic-bezier(0.23, 1, 0.32, 1)`.
- [x] Active buttons and cards trigger `scale(0.98)` press feedback.
- [x] Full `prefers-reduced-motion` compliance.
- [x] Copy conforms to humanizer guidelines: zero filler, zero buzzwords, strictly factual engineering documentation.
