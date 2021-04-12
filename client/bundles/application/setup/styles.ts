export function loadComponentStyles(): void {
  const componentContext = require.context(
    '../../../../app/components',
    true,
    /\.scss$/
  );
  componentContext.keys().forEach((key) => componentContext(key));
}
