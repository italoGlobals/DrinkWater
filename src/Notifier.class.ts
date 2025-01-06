export abstract class Notifier<TEventTypes extends string, TPayloads extends Record<TEventTypes, unknow> {
  private listeners: { [K in TEventTypes]?: ((payload: TPayloads[K]) => void)[] } = {};

  on<K extends TEventTypes>(type: K, callback: (payload: TPayloads[K]) => void): void {
    if (!this.listeners[type]) {
      this.listeners[type] = [];
    }
    this.listeners[type]?.push(callback);
  }

  off<K extends TEventTypes>(type: K, callback: (payload: TPayloads[K]) => void): void {
    if (!this.listeners[type]) return;
    this.listeners[type] = this.listeners[type]?.filter(listener => listener !== callback);
  }

  emit<K extends TEventTypes>(type: K, payload: TPayloads[K]): void {
    this.listeners[type]?.forEach(callback => callback(payload));
  }
}
