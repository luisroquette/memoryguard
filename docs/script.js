const nav = document.querySelector('[data-nav]');
const toggle = document.querySelector('[data-nav-toggle]');
const toggleLabel = document.querySelector('[data-nav-label]');

const setNavigation = (open, returnFocus = false) => {
  nav?.classList.toggle('open', open);
  toggle?.setAttribute('aria-expanded', String(open));
  if (toggleLabel) toggleLabel.textContent = open ? 'Close navigation' : 'Open navigation';
  if (returnFocus) toggle?.focus();
};

toggle?.addEventListener('click', () => {
  setNavigation(toggle.getAttribute('aria-expanded') !== 'true');
});

nav?.querySelectorAll('a').forEach((link) => link.addEventListener('click', () => {
  setNavigation(false);
}));

document.addEventListener('keydown', (event) => {
  if (event.key === 'Escape' && toggle?.getAttribute('aria-expanded') === 'true') {
    setNavigation(false, true);
  }
});

window.addEventListener('resize', () => {
  if (window.innerWidth > 800) setNavigation(false);
}, { passive: true });

document.querySelectorAll('[data-copy]').forEach((button) => {
  button.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(button.dataset.copy);
      const original = button.textContent;
      button.textContent = 'Copied';
      window.setTimeout(() => { button.textContent = original; }, 1600);
    } catch {
      const command = button.previousElementSibling;
      if (command) {
        const selection = window.getSelection();
        const range = document.createRange();
        range.selectNodeContents(command);
        selection.removeAllRanges();
        selection.addRange(range);
      }
      button.textContent = 'Selected';
    }
  });
});
