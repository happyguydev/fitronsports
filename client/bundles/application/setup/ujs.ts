/* eslint-disable global-require */
/* eslint-disable @typescript-eslint/no-var-requires */

export function startUJS(): void {
  require('@rails/ujs').start();
  require('@rails/activestorage').start();
}
