function setupFields(): void {
  const fields = document.querySelectorAll('.field');
  fields.forEach((field) => {
    const icons = field.querySelectorAll('.field__icon');
    const input = field.querySelector(
      '.field__input, input'
    ) as HTMLInputElement;
    input?.addEventListener('blur', () => {
      field.classList.remove('field--active');
      if (input.value) return;
      icons.forEach((icon) => {
        icon?.classList?.remove('field__icon--active');
      });
    });

    input?.addEventListener('focus', () => {
      field.classList.add('field--active');
      icons.forEach((icon) => {
        icon?.classList?.add('field__icon--active');
      });
    });
  });
}

export function setupForms(): void {
  setupFields();
}
