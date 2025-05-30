document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("form-equipaje");
  const tabla = document.getElementById("tabla-equipaje");

  // Función para cargar equipajes desde la base de datos
  function cargarEquipajes() {
    console.log('Intentando cargar equipajes...');
    fetch('/api/equipaje-todos')
      .then(response => {
        console.log('Respuesta del servidor:', response.status, response.statusText);
        return response.json();
      })
      .then(data => {
        console.log('Datos recibidos:', data);
        tabla.innerHTML = ''; // Limpiar tabla
        if (data.length === 0) {
          console.log('No se encontraron equipajes.');
        }
        data.forEach(equipaje => {
          agregarFilaEquipaje(equipaje);
        });
      })
      .catch(err => console.error('Error al cargar equipajes:', err));
  }

  // Función para agregar una fila de equipaje
  function agregarFilaEquipaje(equipaje) {
    const peso = Number(equipaje.peso) || 0; // Convierte a número o usa 0 si es inválido
    console.log('Procesando equipaje:', equipaje, 'Peso convertido:', peso); // Depuración
    const fila = document.createElement("tr");
    fila.innerHTML = `
      <td>${equipaje.numero_documento || 'Sin documento'}</td>
      <td>${equipaje.descripcion || 'Sin descripción'}</td>
      <td>${peso.toFixed(2)}</td>
      <td class="estado">${equipaje.estado || 'Desconocido'}</td>
      <td>
        <select class="selector-estado" data-id="${equipaje.numero_identificacion}">
          <option value="NORMAL" ${equipaje.estado === "NORMAL" ? "selected" : ""}>Normal</option>
          <option value="PERDIDO" ${equipaje.estado === "PERDIDO" ? "selected" : ""}>Perdido</option>
          <option value="DANADO" ${equipaje.estado === "DANADO" ? "selected" : ""}>Dañado</option>
          <option value="EN_INSPECTION" ${equipaje.estado === "EN_INSPECTION" ? "selected" : ""}>En Inspección</option>
          <option value="EN_TRANSITO" ${equipaje.estado === "EN_TRANSITO" ? "selected" : ""}>En Tránsito</option>
        </select>
      </td>
      <td><button class="btn-eliminar" data-id="${equipaje.numero_identificacion}">Eliminar</button></td>
    `;
    tabla.appendChild(fila);
  }

  // Manejador del formulario para agregar nuevo equipaje
  form.addEventListener("submit", (e) => {
    e.preventDefault();

    const doc = document.getElementById("doc-pasajero").value.trim();
    const desc = document.getElementById("desc").value.trim();
    const peso = parseFloat(document.getElementById("peso").value);
    const vueloId = document.getElementById("vuelo-id").value.trim();
    const tipoId = parseInt(document.getElementById("tipo-id").value);

    // Validación básica
    if (!doc || !desc || isNaN(peso) || !vueloId || isNaN(tipoId)) {
      alert("Por favor completa todos los campos correctamente.");
      return;
    }

    const nuevoEquipaje = {
      numero_documento: doc,
      descripcion: desc,
      peso: peso,
      numero_vuelo: vueloId,
      id_estado: 1, // Estado "NORMAL" por defecto
      tipoequipajeid: tipoId
    };

    fetch('/api/equipaje', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(nuevoEquipaje)
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log('Datos devueltos por el servidor:', data);
        alert('Equipaje agregado correctamente');
        agregarFilaEquipaje(data); // Agregar la fila con los datos devueltos
        form.reset();
      })
      .catch(err => alert('Error al agregar equipaje: ' + err.message));
  });

  // Delegación de eventos: cambio de estado o eliminación
  tabla.addEventListener("click", (e) => {
  if (e.target.classList.contains("btn-eliminar")) {
    const id = e.target.dataset.id;
    console.log('Intentando eliminar equipaje con ID:', id); // Depuración
    if (confirm('¿Estás seguro de eliminar este equipaje?')) {
      fetch(`/api/equipaje/${id}`, {
        method: 'DELETE'
      })
        .then(response => {
          console.log('Respuesta del servidor:', response.status, response.statusText); // Depuración
          return response.json().then(data => ({ response, data }));
        })
        .then(({ response, data }) => {
          if (response.ok) {
            e.target.closest("tr").remove();
            alert('Equipaje eliminado correctamente');
          } else {
            alert(`Error al eliminar el equipaje: ${data.error || response.statusText}`);
          }
        })
        .catch(err => alert('Error: ' + err.message));
    }
  }
});document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("form-equipaje");
    const tabla = document.getElementById("tabla-equipaje");
    const btnVolver = document.getElementById("btn-volver");

    // Evento para el botón Volver
    btnVolver.addEventListener("click", () => {
        window.location.href = "index.html";
    });

    // Función para cargar equipajes desde la base de datos
    function cargarEquipajes() {
        console.log('Intentando cargar equipajes...');
        fetch('/api/equipaje-todos')
            .then(response => {
                console.log('Respuesta del servidor:', response.status, response.statusText);
                return response.json();
            })
            .then(data => {
                console.log('Datos recibidos:', data);
                tabla.innerHTML = ''; // Limpiar tabla
                if (data.length === 0) {
                    console.log('No se encontraron equipajes.');
                }
                data.forEach(equipaje => {
                    agregarFilaEquipaje(equipaje);
                });
            })
            .catch(err => console.error('Error al cargar equipajes:', err));
    }

    // Función para agregar una fila de equipaje
    function agregarFilaEquipaje(equipaje) {
        const peso = Number(equipaje.peso) || 0;
        console.log('Procesando equipaje:', equipaje, 'Peso convertido:', peso);
        const fila = document.createElement("tr");
        fila.innerHTML = `
            <td>${equipaje.numero_documento || 'Sin documento'}</td>
            <td>${equipaje.descripcion || 'Sin descripción'}</td>
            <td>${peso.toFixed(2)}</td>
            <td class="estado">${equipaje.estado || 'Desconocido'}</td>
            <td>
                <select class="selector-estado" data-id="${equipaje.numero_identificacion}">
                    <option value="NORMAL" ${equipaje.estado === "NORMAL" ? "selected" : ""}>Normal</option>
                    <option value="PERDIDO" ${equipaje.estado === "PERDIDO" ? "selected" : ""}>Perdido</option>
                    <option value="DANADO" ${equipaje.estado === "DANADO" ? "selected" : ""}>Dañado</option>
                    <option value="EN_INSPECTION" ${equipaje.estado === "EN_INSPECTION" ? "selected" : ""}>En Inspección</option>
                    <option value="EN_TRANSITO" ${equipaje.estado === "EN_TRANSITO" ? "selected" : ""}>En Tránsito</option>
                </select>
            </td>
            <td><button class="btn-eliminar" data-id="${equipaje.numero_identificacion}">Eliminar</button></td>
        `;
        tabla.appendChild(fila);
    }

    // Manejador del formulario para agregar nuevo equipaje
    form.addEventListener("submit", (e) => {
        e.preventDefault();

        const doc = document.getElementById("doc-pasajero").value.trim();
        const desc = document.getElementById("desc").value.trim();
        const peso = parseFloat(document.getElementById("peso").value);
        const vueloId = document.getElementById("vuelo-id").value.trim();
        const tipoId = parseInt(document.getElementById("tipo-id").value);

        if (!doc || !desc || isNaN(peso) || !vueloId || isNaN(tipoId)) {
            alert("Por favor completa todos los campos correctamente.");
            return;
        }

        const nuevoEquipaje = {
            numero_documento: doc,
            descripcion: desc,
            peso: peso,
            numero_vuelo: vueloId,
            id_estado: 1,
            tipoequipajeid: tipoId
        };

        fetch('/api/equipaje', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(nuevoEquipaje)
        })
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log('Datos devueltos por el servidor:', data);
                alert('Equipaje agregado correctamente');
                agregarFilaEquipaje(data);
                form.reset();
            })
            .catch(err => alert('Error al agregar equipaje: ' + err.message));
    });

    // Delegación de eventos: cambio de estado o eliminación
    tabla.addEventListener("click", (e) => {
        if (e.target.classList.contains("btn-eliminar")) {
            const id = e.target.dataset.id;
            console.log('Intentando eliminar equipaje con ID:', id);
            if (confirm('¿Estás seguro de eliminar este equipaje?')) {
                fetch(`/api/equipaje/${id}`, { method: 'DELETE' })
                    .then(response => {
                        console.log('Respuesta del servidor:', response.status, response.statusText);
                        return response.json().then(data => ({ response, data }));
                    })
                    .then(({ response, data }) => {
                        if (response.ok) {
                            e.target.closest("tr").remove();
                            alert('Equipaje eliminado correctamente');
                        } else {
                            alert(`Error al eliminar el equipaje: ${data.error || response.statusText}`);
                        }
                    })
                    .catch(err => alert('Error: ' + err.message));
            }
        }
    });

    tabla.addEventListener("change", (e) => {
        if (e.target.classList.contains("selector-estado")) {
            const nuevoEstado = e.target.value;
            const id = e.target.dataset.id;
            const celdaEstado = e.target.closest("tr").querySelector(".estado");
            celdaEstado.textContent = nuevoEstado;

            const estadoMap = { 'NORMAL': 1, 'PERDIDO': 2, 'DANADO': 3, 'EN_INSPECTION': 4, 'EN_TRANSITO': 5 };
            const idEstado = estadoMap[nuevoEstado];

            fetch(`/api/equipaje/${id}/estado`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id_estado: idEstado })
            })
                .then(response => response.json())
                .then(data => {
                    alert('Estado actualizado correctamente');
                })
                .catch(err => {
                    alert('Error al actualizar el estado: ' + err.message);
                    celdaEstado.textContent = data.estado;
                });
        }
    });

    // Cargar equipajes al iniciar
    cargarEquipajes();
});

  tabla.addEventListener("change", (e) => {
    if (e.target.classList.contains("selector-estado")) {
      const nuevoEstado = e.target.value;
      const id = e.target.dataset.id;
      const celdaEstado = e.target.closest("tr").querySelector(".estado");
      celdaEstado.textContent = nuevoEstado;

      const estadoMap = {
        'NORMAL': 1,
        'PERDIDO': 2,
        'DANADO': 3,
        'EN_INSPECTION': 4,
        'EN_TRANSITO': 5
      };
      const idEstado = estadoMap[nuevoEstado];

      fetch(`/api/equipaje/${id}/estado`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id_estado: idEstado })
      })
        .then(response => response.json())
        .then(data => {
          alert('Estado actualizado correctamente');
        })
        .catch(err => {
          alert('Error al actualizar el estado: ' + err.message);
          celdaEstado.textContent = data.estado; // Revertir si falla
        });
    }
  });

  // Cargar equipajes al iniciar
  cargarEquipajes();
});