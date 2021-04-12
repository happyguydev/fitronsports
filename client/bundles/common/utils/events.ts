export enum Events {
  facilitySearchSelected = 'facility-search-selected',
  facilitySearchClosed = 'facility-search-closed',
  attachmentUpdated = 'attachment-updated',
}

export type Event<T = Record<string, any>> = CustomEvent & {
  detail: T;
};

export function dispatchEvent<T = Record<string, any>>(
  eventKey: Events,
  params?: T,
  container?: Element
): void {
  const event = new CustomEvent(eventKey, { detail: params });
  if (container) {
    container.dispatchEvent(event);
  } else {
    window.dispatchEvent(event);
  }
}
