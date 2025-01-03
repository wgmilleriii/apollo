// Constants
const VERSIONS = ['battle', 'war', 'chaos'];
const FADE_DURATION = 300;

// Utility functions
const createElement = (tag, className, text = '') => {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (text) element.textContent = text;
    return element;
};

// Load lyrics
const loadLyrics = async (version) => {
    try {
        const response = await fetch(`gwarenergetic/${version}.txt`);
        if (!response.ok) throw new Error('Lyrics not found');
        
        const text = await response.text();
        const container = document.getElementById(`${version}-lyrics`);
        
        // Fade out
        container.style.opacity = '0';
        
        setTimeout(() => {
            container.innerText = text;
            // Fade in
            container.style.opacity = '1';
        }, FADE_DURATION);
        
    } catch (err) {
        console.error(`Error loading ${version} lyrics:`, err);
        document.getElementById(`${version}-lyrics`).innerHTML = 
            '<p class="error" role="alert">LYRICS LOST IN BATTLE!</p>';
    }
};

// Blood splatter effect
const createSplatter = (e) => {
    const splatter = createElement('div', 'splatter');
    const size = Math.random() * 50 + 20;
    
    splatter.style.width = `${size}px`;
    splatter.style.height = `${size}px`;
    splatter.style.left = `${e.pageX - size/2}px`;
    splatter.style.top = `${e.pageY - size/2}px`;
    
    document.body.appendChild(splatter);
    setTimeout(() => splatter.remove(), 2000);
};

// Initialize
const init = () => {
    // Load all lyrics
    VERSIONS.forEach(loadLyrics);
    
    // Add click effect
    document.addEventListener('click', createSplatter);
    
    // Add keyboard navigation
    document.querySelectorAll('.metal-card').forEach(card => {
        card.setAttribute('tabindex', '0');
        card.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                card.querySelector('audio').focus();
            }
        });
    });
};

// Start when DOM is ready
document.addEventListener('DOMContentLoaded', init); 