import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="retain-check"
export default class extends Controller {
  connect() {
    console.log("Connecting to data-controller='retain-check'")
    this.loadCheckedStateFromLocalStorage();
  }
  toggleCheckbox(event) {
    const checkbox = event.currentTarget;
    const key = this.element.dataset.checkboxKey;
    const checkedItems = this.getCheckedItemsFromLocalStorage(key) || [];

    if (checkbox.checked) {
      checkedItems.push(checkbox.value);
    } else {
      const index = checkedItems.indexOf(checkbox.value);
      if (index !== -1) checkedItems.splice(index, 1);
    }

    this.saveCheckedItemsToLocalStorage(key, checkedItems);
  }

  loadCheckedStateFromLocalStorage() {
    const key = this.element.dataset.checkboxKey;
    const checkedItems = this.getCheckedItemsFromLocalStorage(key) || [];

    this.element.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
      checkbox.checked = checkedItems.includes(checkbox.value);
    });
  }

  getCheckedItemsFromLocalStorage(key) {
    const items = localStorage.getItem(key);
    return items ? JSON.parse(items) : null;
  }

  saveCheckedItemsToLocalStorage(key, items) {
    localStorage.setItem(key, JSON.stringify(items));
  }

};
