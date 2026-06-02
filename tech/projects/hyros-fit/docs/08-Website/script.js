// ===== Scroll-triggered fade-in =====
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, observerOptions);

document.querySelectorAll('section').forEach(section => {
  observer.observe(section);
});

// ===== FAQ Accordion =====
document.querySelectorAll('.faq-question').forEach(button => {
  button.addEventListener('click', () => {
    const item = button.parentElement;
    const isActive = item.classList.contains('active');
    
    // Close all
    document.querySelectorAll('.faq-item').forEach(faq => {
      faq.classList.remove('active');
    });
    
    // Open clicked if it wasn't active
    if (!isActive) {
      item.classList.add('active');
    }
  });
});

// ===== Navbar scroll effect =====
let lastScroll = 0;
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
  const currentScroll = window.pageYOffset;
  
  if (currentScroll > 100) {
    navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)';
  } else {
    navbar.style.boxShadow = 'none';
  }
  
  lastScroll = currentScroll;
});

// ===== Hero mockup animation =====
document.addEventListener('DOMContentLoaded', () => {
  const progressFill = document.querySelector('.hero .progress-fill');
  if (progressFill) {
    setTimeout(() => {
      progressFill.style.width = '60%';
    }, 800);
  }
});
