/* eslint-disable @typescript-eslint/ban-ts-comment */
import { Application } from 'stimulus';

/**
 * Loads all stimulus controllers into a global context
 */
export function loadControllers(): void {
  const application = Application.start();
  const context = require.context('../controllers', true, /.ts$/);
  context.keys().forEach((key) => {
    const { default: Controller } = context(key);

    const identifier =
      Controller?.identifier ??
      key
        .substr(2)
        .replace('.tsx', '')
        .replace('.ts', '')
        .replace(/-controller/, '')
        .toLowerCase()
        .split('/')
        .join('--');

    if (!Controller) return;
    application.register(identifier, Controller);
    /* console.log(
      `[stimulus] registered controller with identifier ${identifier}`
    );
    */
  });
}
