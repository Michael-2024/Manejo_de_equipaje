document.addEventListener('DOMContentLoaded', function () {
    // Elementos del DOM
    const formulario = document.getElementById('pasajeroForm'); // Cambié a 'pasajeroForm' como en el HTML ajustado
    const loading = document.getElementById('loading');
    const resultados = document.getElementById('resultados');

    // Manejador del evento submit
    formulario.addEventListener('submit', function (e) {
        e.preventDefault();
        const documento = document.getElementById('documento').value.trim();

        // Validación básica
        if (!documento) {
            mostrarError('Por favor, ingrese un número de documento.');
            return;
        }

        // Mostrar indicador de carga
        mostrarCarga();

        // Realizar la consulta al servidor
        consultarEquipaje(documento);
    });

    // Función para consultar el equipaje
    function consultarEquipaje(documento) {
        fetch(`/api/pasajero-equipaje?documento=${encodeURIComponent(documento)}`)
            .then(manejarRespuesta)
            .then(mostrarEquipaje)
            .catch(manejarError)
            .finally(ocultarCarga);
    }

    // Función para manejar la respuesta del servidor
    function manejarRespuesta(response) {
        if (!response.ok) {
            return response.json().then((err) => {
                throw new Error(err.error || 'Error en la solicitud');
            }).catch(() => {
                throw new Error(
                    response.status === 404
                        ? 'No se encontró pasajero con ese documento.'
                        : `Error ${response.status}: ${response.statusText}`
                );
            });
        }
        return response.json();
    }

    // Función para mostrar los resultados
    function mostrarEquipaje(data) {
        resultados.innerHTML = '';

        if (!data || data.length === 0) {
            mostrarMensaje('No se encontró equipaje para este pasajero.', 'info');
            return;
        }

        data.forEach((equipaje) => {
            const div = document.createElement('div');
            div.className = 'equipaje-item';
            div.innerHTML = `
                <p><strong>ID Equipaje:</strong> ${equipaje.equipajeid || 'No disponible'}</p>
                <p><strong>Última Ubicación:</strong> ${equipaje.ubicacion || 'Sin datos'}</p>
                <p><strong>Fecha/Hora:</strong> ${equipaje.fechahora ? new Date(equipaje.fechahora).toLocaleString() : 'Sin datos'}</p>
                <p><strong>Estado:</strong> ${equipaje.estado || 'Desconocido'}</p>
                <p><strong>Observaciones:</strong> ${equipaje.observaciones || 'Ninguna'}</p>
            `;
            resultados.appendChild(div);
        });
    }

    // Función para manejar errores
    function manejarError(error) {
        console.error('Error:', error);
        mostrarError(error.message || 'Ocurrió un error inesperado.');
    }

    // Función para mostrar el indicador de carga
    function mostrarCarga() {
        loading.style.display = 'block';
        resultados.innerHTML = '';
    }

    // Función para ocultar el indicador de carga
    function ocultarCarga() {
        loading.style.display = 'none';
    }

    // Función para mostrar mensajes de error
    function mostrarError(mensaje) {
        resultados.innerHTML = `<div class="results error">${mensaje}</div>`;
    }

    // Función para mostrar mensajes informativos
    function mostrarMensaje(mensaje, tipo) {
        resultados.innerHTML = `<div class="results ${tipo}">${mensaje}</div>`;
    }
});