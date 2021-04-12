import { startTurbolinks } from './turbolinks';
import { startUJS } from './ujs';
import { setupForms } from './forms';
import { loadControllers } from './stimulus';
import { loadComponentStyles } from './styles';
import { setupDashboard } from './dashboard';
import { setupButtons } from './buttons';
import { removeFlashesAutomatically } from './flashes';

export function setup(): void {
  startTurbolinks();
  startUJS();
  loadControllers();
  loadComponentStyles();

  document.addEventListener('turbolinks:load', () => {
    setupForms();
    setupDashboard();
    setupButtons();
    removeFlashesAutomatically();
  });
}
