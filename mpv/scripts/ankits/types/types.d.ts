export { }

declare global {
  // Timers (global)
  function setTimeout(handler: string | Function, timeout?: number, ...arguments: any[]): number;
  function clearTimeout(id: number | undefined): void;
  function setInterval(handler: string | Function, timeout?: number, ...arguments: any[]): number;
  function clearInterval(id: number | undefined): void;

  // Additional utilities
  function print(...msg: unknown[]): void;
  function dump(...msg: unknown[]): void;
  function exit(): void;
  namespace mp {
    namespace input {
      function get(params: any);
      function terminate();
    }
  }
}
