export function setupDashboard(): void {
  const selectors = {
    header: '.js-dashboard-header',
    wrapper: '.js-dashboard-wrapper',
  };

  const isDashboard = JSON.parse(
    document.querySelector('body')?.dataset.dashboard ?? 'false'
  );

  if (!isDashboard) {
    return;
  }

  const header = document.querySelector(selectors.header);
  const toolbar = header?.querySelector('.js-dashboard-toolbar');
  const wrapper = document.querySelector(selectors.wrapper);

  if (toolbar) {
    header?.classList.add('dashboard-header--toolbar');
    wrapper?.classList.add('dashboard-wrapper--with-toolbar');
  }
}
