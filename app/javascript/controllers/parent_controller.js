import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['child', 'default']

  connect() {
    this.toggleChildren()
    console.log('Hello from parent controller');
  }

  toggleChildren() {
    const children = this.childTargets;
    
    // Function to check if an element has the 'hidden' class
    function hasHiddenClass(element) {
      return element.classList.contains('hidden');
    }

    // Check if any element in the childTargets has the 'hidden' class
    const hasHiddenElement = Array.from(children).every(hasHiddenClass);

    if (hasHiddenElement) {
      this.defaultTarget.innerHTML = 'No remittance yet';
    } else {
      this.defaultTarget.innerHTML = '';
    }
  }
}