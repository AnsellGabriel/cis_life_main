function toggleForms() {
    const elem = document.getElementById('formCategory');
    const agentForm = document.getElementById('agentForm');
    const coopForm = document.getElementById('coopForm');
    const employeeForm = document.getElementById('employeeForm');

    elem.addEventListener('change', () => {
        if (elem.value === 'Agent') {
            agentForm.style.display = 'block';
            coopForm.style.display = 'none';
            employeeForm.style.display = 'none';
        } else if (elem.value === 'Coop') {
            agentForm.style.display = 'none';
            coopForm.style.display = 'block';
            employeeForm.style.display = 'none';
        } else if (elem.value === 'Employee') {
            agentForm.style.display = 'none';
            coopForm.style.display = 'none';
            employeeForm.style.display = 'block';
        }
    });
};

