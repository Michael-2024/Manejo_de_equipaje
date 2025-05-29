document.addEventListener('DOMContentLoaded', () => {
  const estados = [
    { id: 1, nombre: 'Registrado' },
    { id: 2, nombre: 'Cargado' },
    { id: 3, nombre: 'En vuelo' },
    { id: 4, nombre: 'Descargado' },
    { id: 5, nombre: 'Entregado' }
  ];

  function cargarEquipajes() {
    fetch('/api/equipaje-todos')
      .then(res => res.json())
      .then(data => {
        const tabla = document.getElementById('tabla-equipaje');
        tabla.innerHTML = '';

        data.forEach(e => {
          const estadoIdActual = estados.find(estado => estado.nombre === e.estado)?.id || 1;
          const opcionesEstado = estados.map(estado => 
            `<option value="${estado.id}" ${estado.id === estadoIdActual ? 'selected' : ''}>${estado.nombre}</option>`
          ).join('');

          const fila = document.createElement('tr');
          fila.innerHTML = `
            <td>${e.nombre_pasajero}</td>
            <td>${e.descripcion}</td>
            <td>${e.peso}</td>
            <td>${e.estado || 'Sin estado'}</td>
            <td>
              <select id="estado-${e.equipajeid}">
                ${opcionesEstado}
              </select>
            </td>
            <td>
              <button onclick="cambiarEstado(${e.equipajeid})" class="btn">Cambiar Estado</button>
            </td>
          `;
          tabla.appendChild(fila);
        });
      })
      .catch(err => alert('Error al cargar equipajes: ' + err.message));
  }

  window.cambiarEstado = function (equipajeid) {
    const select = document.getElementById(`estado-${equipajeid}`);
    const estadoid = parseInt(select.value);

    console.log("Equipaje ID:", equipajeid);
    console.log("Estado seleccionado:", estadoid);

    if (!estadoid || estadoid < 1 || estadoid > 5) {
      alert('Estado inválido');
      return;
    }

    fetch(`/api/equipaje/${equipajeid}/estado`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ estadoid })
    })
      .then(res => {
        console.log("Respuesta del servidor:", res.status);
        return res.json();
      })
      .then(data => {
        console.log('Estado actualizado:', data);
        alert('Estado actualizado correctamente');
        cargarEquipajes();
      })
      .catch(err => {
        console.error('Error en fetch:', err);
        alert('Error al cambiar el estado: ' + err.message);
      });
  };

  document.getElementById('form-equipaje').addEventListener('submit', e => {
    e.preventDefault();

    const data = {
      documento: document.getElementById('doc-pasajero').value.trim(),
      descripcion: document.getElementById('desc').value.trim(),
      peso: parseFloat(document.getElementById('peso').value),
      vueloid: parseInt(document.getElementById('vuelo-id').value),
      tipoequipajeid: parseInt(document.getElementById('tipo-id').value)
    };

    if (!data.documento || !data.descripcion || isNaN(data.peso) || isNaN(data.vueloid) || isNaN(data.tipoequipajeid)) {
      alert('Por favor, complete todos los campos correctamente.');
      return;
    }

    fetch('/api/equipaje', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
      .then(res => {
        if (!res.ok) throw new Error('Error al crear equipaje: ' + res.statusText);
        return res.json();
      })
      .then(result => {
        alert('Equipaje creado con éxito');
        cargarEquipajes();
        document.getElementById('form-equipaje').reset();
      })
      .catch(err => alert('Error al crear equipaje: ' + err.message));
  });

  cargarEquipajes();
});
