import { Controller } from 'stimulus';
import IMask from 'imask';

class IInputMaskController extends Controller {
  public inputTarget: HTMLInputElement;
  public imask: IMask.InputMask<any>;
}

class InputMaskController extends (Controller as typeof IInputMaskController) {
  static targets = ['input'];
  options = {};

  get mask(): string | null {
    return this.data.get('mask');
  }

  connect = (): void => {
    if (!this.mask) return;

    this.imask = IMask(this.inputTarget, {
      mask: this.mask,
      ...this.options,
    });
  };
}

export default InputMaskController;
