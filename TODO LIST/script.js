document.getElementById('addTaskBtn').addEventListener('click', function () {
  const taskInput = document.getElementById('taskInput');
  const taskList = document.getElementById('taskList');
  const noTasksMsg = document.getElementById('noTasksMsg');
  const statusMsg = document.getElementById('statusMsg'); 
  
  const task = taskInput.value.trim();

  if (task) {
    const li = document.createElement('li');
    li.textContent = task;

    const deleteBtn = document.createElement('button');
    deleteBtn.textContent = 'Delete';
    deleteBtn.style.marginLeft = '10px';
    deleteBtn.style.backgroundColor = '#dc3545'; 
    deleteBtn.style.color = 'white';
    deleteBtn.style.border = 'none';
    deleteBtn.style.borderRadius = '4px';
    deleteBtn.style.padding = '4px 8px';
    deleteBtn.style.cursor = 'pointer';

    deleteBtn.addEventListener('click', function () {
      li.remove();
      statusMsg.textContent = 'Task was deleted successfully!';
      statusMsg.style.color = '#dc3545'; 
      if (taskList.children.length === 0) {
        noTasksMsg.style.display = 'block';
      }
    
      setTimeout(() => {
        statusMsg.textContent = '';
      }, 3000);
    });

    li.appendChild(deleteBtn);
    taskList.appendChild(li);

    taskInput.value = ''; 
    noTasksMsg.style.display = 'none'; 
    statusMsg.textContent = 'Task was added successfully!'; 
    statusMsg.style.color = '#28a745'; 

    setTimeout(() => {
      statusMsg.textContent = '';
    }, 3000);
  }
});

document.getElementById('taskInput').addEventListener('input', function () {
  const taskList = document.getElementById('taskList');
  const noTasksMsg = document.getElementById('noTasksMsg');

  if (taskList.children.length === 0) {
    noTasksMsg.style.display = 'block'; 
  }
});




  