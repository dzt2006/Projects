document.getElementById('year').textContent = new Date().getFullYear();

const nav = document.querySelector('.nav');
const onScroll = () => nav.classList.toggle('scrolled', window.scrollY > 8);
window.addEventListener('scroll', onScroll, { passive: true });
onScroll();

const io = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.animationPlayState = 'running';
      io.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal').forEach(el => io.observe(el));

const hashTarget = () => document.getElementById(decodeURIComponent(location.hash.slice(1)));
if (location.hash) {
  window.addEventListener('load', () => {
    const el = hashTarget();
    if (el) el.scrollIntoView({ behavior: 'instant', block: 'start' });
  });
}
window.addEventListener('hashchange', () => {
  const el = hashTarget();
  if (el) el.scrollIntoView({ block: 'start' });
});

console.log('%c欢迎来到 dztfun.cyou', 'color:#4d7fd6;font-size:14px;font-weight:600;');