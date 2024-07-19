import { renderAsync } from 'docx-preview';

document.getElementById('file-input').addEventListener('change', async (event) => {
    const file = event.target.files[0];
    if (file) {
        const arrayBuffer = await file.arrayBuffer();
        const container = document.getElementById('docx-container');
        renderAsync(arrayBuffer, container);
    }
});
