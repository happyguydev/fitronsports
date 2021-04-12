import { Controller } from 'stimulus';

class IAlertController extends Controller {
  public titleTarget: HTMLSpanElement;
  public messagesTarget: HTMLUListElement;
}

class AlertController extends (Controller as typeof IAlertController) {
  // MARK: - Targets
  public static targets = ['title', 'messages'];

  private isInitiallyVisible = this.data.get('initiallyVisible') ?? 'false';
  public visible = false;

  // MARK: - Public Methods

  public connect(): void {
    const element = this.element as HTMLDivElement;

    if (!JSON.parse(this.isInitiallyVisible)) {
      element.classList.add('alert--hidden');
    } else {
      element.classList.remove('alert--hidden');
    }
  }

  public show(message: string): void {
    if(!message) return;
    this.visible = true;
    this.element.classList.remove('alert--hidden');

    if (message) {
      this.titleTarget.textContent = message;
    }
  }

  public showList(lists: Record<string, any>): void {
    if (lists.length === 0) return;
    this.visible = true;
    this.element.classList.remove('alert--hidden');

    if (lists) {
      let listHTML = '';
      for(let k in lists) {
        listHTML += `<li>${k} ${lists[k]}</li>`;
      }
      this.messagesTarget.innerHTML = listHTML;
    }
  }

  public close(): void {
    this.visible = false;
    this.element.classList.add('alert--hidden');
  }
}

export default AlertController;
