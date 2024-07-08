export function toggleClass(element: HTMLElement, className: string) {
	return element.classList.toggle(className);
}

export function elementHasClass(element: HTMLElement, className: string) {
	return element.classList.contains(className);
}
