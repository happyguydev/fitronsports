/* eslint-disable no-underscore-dangle */
import { Controller } from 'stimulus';

class IModalController extends Controller {
  public overlayTarget: HTMLDivElement;
  public contentTarget: HTMLDivElement;
}

class ModalController extends (Controller as typeof IModalController) {
  static targets = ['overlay', 'content'];

  public isOpen = false;

  public get duration(): number {
    const dataDuration = this.data.get('duration') ?? '150';
    return parseInt(dataDuration, 10);
  }

  public open = (): void => {
    this.isOpen = true;
    this.element.classList.add('modal--visible');
    this._open();
    setTimeout(() => {
      this.overlayTarget.classList.add('modal__overlay--visible');
      this.contentTarget.classList.add('modal__content--visible');
    }, this.duration);
  };

  public close = (): void => {
    this.isOpen = false;
    this._close();
    this.overlayTarget.classList.remove('modal__overlay--visible');
    this.contentTarget.classList.remove('modal__content--visible');

    setTimeout(() => {
      this.element.classList.remove('modal--visible');
    }, this.duration);
  };

  _close = (): void => {
    // nothing
  };

  _open = (): void => {
    // nothing
  };

  public toggle = (): void => {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  };
}

export default ModalController;
