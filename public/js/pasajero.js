document.addEventListener('DOMContentLoaded', function () {
    const formulario = document.getElementById('pasajeroForm');
    const loading = document.getElementById('loading');
    const resultados = document.getElementById('resultados');

    formulario.addEventListener('submit', function (e) {
        e.preventDefault();
        const documento = document.getElementById('documento').value.trim();

        if (!documento) {
            mostrarError('Por favor, ingrese un número de documento.');
            return;
        }

        mostrarCarga();
        consultarEquipaje(documento);
    });

    function consultarEquipaje(documento) {
        fetch(`/api/pasajero-equipaje?documento=${encodeURIComponent(documento)}`)
            .then(manejarRespuesta)
            .then(mostrarEquipaje)
            .catch(manejarError)
            .finally(ocultarCarga);
    }

    function manejarRespuesta(response) {
        if (!response.ok) {
            return response.json().then((err) => {
                throw new Error(err.error || 'Error en la solicitud');
            }).catch(() => {
                throw new Error(
                    response.status === 404
                        ? 'No se encontró equipaje con ese documento.'
                        : `Error ${response.status}: ${response.statusText}`
                );
            });
        }
        return response.json();
    }

    function mostrarEquipaje(data) {
        resultados.innerHTML = '';

        if (!data || data.length === 0) {
            mostrarMensaje('No se encontró equipaje para este pasajero.', 'info');
            return;
        }

        const tabla = document.createElement('table');
        tabla.innerHTML = `
            <thead>
                <tr>
                    <th>ID Equipaje</th>
                    <th>Descripción</th>
                    <th>Peso</th>
                    <th>Estado</th>
                    <th>Última Ubicación</th>
                    <th>Fecha/Hora</th>
                    <th>Observaciones</th>
                </tr>
            </thead>
            <tbody>
                ${data.map(eq => `
                    <tr>
                        <td>${eq.equipajeid || 'N/A'}</td>
                        <td>${eq.descripcion || 'Sin descripción'}</td>
                        <td>${eq.peso || 'N/A'} kg</td>
                        <td>${eq.estado || 'Desconocido'}</td>
                        <td>${eq.ubicacion || 'Sin datos'}</td>
                        <td>${eq.fechahora ? new Date(eq.fechahora).toLocaleString() : 'Sin datos'}</td>
                        <td>${eq.observaciones || 'Ninguna'}</td>
                    </tr>
                `).join('')}
            </tbody>
        `;
        resultados.appendChild(tabla);
    }

    function manejarError(error) {
        console.error('Error:', error);
        mostrarError(error.message || 'Ocurrió un error inesperado.');
    }

    function mostrarCarga() {
        loading.style.display = 'block';
        resultados.innerHTML = '';
    }

    function ocultarCarga() {
        loading.style.display = 'none';
    }

    function mostrarError(mensaje) {
        resultados.innerHTML = `<div class="results error">${mensaje}</div>`;
    }

    function mostrarMensaje(mensaje, tipo) {
        resultados.innerHTML = `<div class="results ${tipo}">${mensaje}</div>`;
    }
});