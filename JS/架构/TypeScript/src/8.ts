namespace c {
    interface Event {
        timestamp: number
    }
    interface MouseEvent extends Event {
        eventX: number
        eventY: number
    }
    interface KeyEvent extends Event {
        keyCode: number
    }
    function addEventListener(eventType: string, handler: (event: Event) => void) {

    }
    addEventListener('click', (event: Event) => { });
    addEventListener('click', (event: MouseEvent) => { });
    addEventListener('click', (event: KeyEvent) => { });
}
export { }