function toggleForms() {
    const roleSelection = document.getElementById('formCategory');
    const agentForm = document.getElementById('agentForm');
    const coopForm = document.getElementById('coopForm');
    const employeeForm = document.getElementById('employeeForm');

    roleSelection.addEventListener('change', () => {
        if (roleSelection.value === 'Agent') {
            agentForm.style.display = 'block';
            coopForm.style.display = 'none';
            employeeForm.style.display = 'none';
        } else if (roleSelection.value === 'Coop') {
            agentForm.style.display = 'none';
            coopForm.style.display = 'block';
            employeeForm.style.display = 'none';
        } else if (roleSelection.value === 'Employee') {
            agentForm.style.display = 'none';
            coopForm.style.display = 'none';
            employeeForm.style.display = 'block';
        }
    });
};

