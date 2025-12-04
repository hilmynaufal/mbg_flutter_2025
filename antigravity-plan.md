# Plan: Restructure Sub-Dashboards (Posyandu, MBG, Bedas Menanam)

This plan outlines the steps to upgrade the sub-dashboards to match the aesthetic quality of the main `HomeView`, including banners, news, and specific statistics.

## Goal
Create premium-looking dashboards for Posyandu, MBG, and Bedas Menanam with:
-   **SliverAppBar**: With gradients and user/dashboard info.
-   **Banner Section**: Using `BannerCarouselWidget`.
-   **Statistics Section**: Displaying dummy data (e.g., total records).
-   **Menu Section**: Grid of "cool" menu items with icons.
-   **News Section**: Using `NewsCardWidget`.

## Checklist

### 1. Preparation
- [ ] Review `HomeView` implementation for reference.
- [ ] Ensure `BannerCarouselWidget` and `NewsCardWidget` are accessible and reusable.

### 2. Bedas Menanam Dashboard
- [ ] **Controller**: `BedasMenanamDashboardController`
    - [ ] Add dummy statistics (e.g., `totalTrees`, `activeFarmers`).
    - [ ] Define menu items list (Icon, Title, Route).
- [ ] **View**: `BedasMenanamDashboardView`
    - [ ] Implement `SliverAppBar` with Green theme (Bedas Menanam identity).
    - [ ] Add `BannerCarouselWidget`.
    - [ ] Add **Statistics Section** (Cards showing numbers).
    - [ ] Add **Menu Grid** (Styled like `HomeView` services).
    - [ ] Add `NewsCardWidget` section.

### 3. Posyandu Dashboard
- [ ] **Controller**: `PosyanduDashboardController`
    - [ ] Add dummy statistics (e.g., `totalPosyandu`, `totalChildren`).
    - [ ] Define menu items list.
- [ ] **View**: `PosyanduDashboardView`
    - [ ] Implement `SliverAppBar` with Red/Pink theme (Posyandu identity).
    - [ ] Add `BannerCarouselWidget`.
    - [ ] Add **Statistics Section**.
    - [ ] Add **Menu Grid**.
    - [ ] Add `NewsCardWidget` section.

### 4. MBG Dashboard (MBG & SPPG)
- [ ] **Controller**: `MbgSppgDashboardController`
    - [ ] Add dummy statistics (e.g., `totalMbg`, `totalSppg`).
    - [ ] Define menu items list.
- [ ] **View**: `MbgSppgDashboardView`
    - [ ] Implement `SliverAppBar` with Blue theme (MBG identity).
    - [ ] Add `BannerCarouselWidget`.
    - [ ] Add **Statistics Section**.
    - [ ] Add **Menu Grid**.
    - [ ] Add `NewsCardWidget` section.

## Design Notes
-   **Statistics Card**: Should be visually appealing, maybe with a small icon and a gradient background or a clean white card with a shadow.
-   **Menus**: Use `FontAwesomeIcons` or standard `Icons` consistent with the theme.
-   **Consistency**: Maintain the `CustomScrollView` structure from `HomeView`.
