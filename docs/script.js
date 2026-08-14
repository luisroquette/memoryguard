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

const pressureLab = document.querySelector('[data-pressure-lab]');
if (pressureLab) {
  const states = {
    healthy: {
      memory: '38%', kernel: 'Healthy', swap: '2.4 GB', gauge: '38%',
      title: 'No intervention', copy: 'Memory is healthy. Both recognized builds continue running.', rule: 'observe_only',
      newerStatus: 'RUNNING', newerClass: '', sampleClass: '', olderProgress: '72%', newerProgress: '48%'
    },
    pressure: {
      memory: '8%', kernel: 'Critical', swap: '420 MB', gauge: '8%',
      title: 'Newest build paused', copy: 'Two heavy builds qualify. The older build keeps moving; the newest waits safely.', rule: 'pause_newest_eligible',
      newerStatus: 'PAUSED', newerClass: 'is-paused', sampleClass: '', olderProgress: '86%', newerProgress: '48%'
    },
    recovery: {
      memory: '31%', kernel: 'Healthy', swap: '1.7 GB', gauge: '31%',
      title: 'All builds resumed', copy: 'Two consecutive healthy samples passed. MemoryGuard released the paused group.', rule: 'resume_after_2_samples',
      newerStatus: 'RESUMED', newerClass: 'is-resumed', sampleClass: 'is-complete', olderProgress: '94%', newerProgress: '63%'
    }
  };
  const buttons = [...pressureLab.querySelectorAll('[data-lab-state]')];
  const readout = pressureLab.querySelector('.decision-readout');
  const renderState = (name) => {
    const state = states[name];
    if (!state) return;
    buttons.forEach((button) => button.setAttribute('aria-pressed', String(button.dataset.labState === name)));
    pressureLab.querySelector('[data-memory-value]').textContent = state.memory;
    pressureLab.querySelector('[data-kernel-value]').textContent = state.kernel;
    pressureLab.querySelector('[data-swap-value]').textContent = state.swap;
    pressureLab.querySelector('[data-gauge-ring]').style.setProperty('--gauge', state.gauge);
    pressureLab.querySelector('[data-decision-title]').textContent = state.title;
    pressureLab.querySelector('[data-decision-copy]').textContent = state.copy;
    pressureLab.querySelector('[data-decision-rule]').textContent = state.rule;
    pressureLab.querySelector('[data-newer-status]').textContent = state.newerStatus;
    pressureLab.querySelector('[data-older-progress]').style.width = state.olderProgress;
    pressureLab.querySelector('[data-newer-progress]').style.width = state.newerProgress;
    pressureLab.querySelector('[data-newer-build]').className = `build-lane newer-build ${state.newerClass}`.trim();
    pressureLab.querySelector('[data-recovery-samples]').className = `recovery-samples ${state.sampleClass}`.trim();
    readout.classList.remove('is-updating');
    void readout.offsetWidth;
    readout.classList.add('is-updating');
  };
  buttons.forEach((button) => button.addEventListener('click', () => renderState(button.dataset.labState)));
}
