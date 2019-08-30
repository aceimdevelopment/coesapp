

	function loadData(type, id, callback) {
		let currentUrl = window.location.href
		let controller = (currentUrl.includes('inscripcionsecciones')) ? 'inscripcionsecciones' : 'secciones'
		if (type == 'asignatura' || ((controller == 'secciones') && (type == 'catedra' || id == 'pci'))){
			getSecciones(type, id, controller)
		}else{
			paintTabObjects(type,id, controller, callback)
		}
	}

	function updatePage(type, id){
		limpiarResultados()
		setTab(type, id)
		setHeader()
		loadData(type, id)
	}

	function setHeader(){
		// console.log(sessionStorage.getItem('escuela'))
		if(sessionStorage.getItem('escuela') == 'pci') {
			$('#normalHeader').addClass('d-none')
			$('#pciHeader').removeClass('d-none')
		}else{
			$('#normalHeader').removeClass('d-none')
			$('#pciHeader').addClass('d-none')
		}
	}

	function limpiarResultados(){
		$('#responseTotal').hide()
		$('#tableResponse').html("")
		$('#noEncontrado').hide()
		$("#resultado tbody").html("")
		$("#descAsignatura").html("") 
		$('#btnNewSeccion').hide()
	}

	function setAsignaturaToNewSeccion(id, desc){
		$('#_seccionasignatura_id').val(`${id}`)
		$('#newSeccionTitle').html(`Nueva Sección para ${desc}`)
	}

	function showNewAsig(id) {
		let desc = document.getElementById(`asignatura_${id}`).textContent.split("\n")[0]
		console.log(`desc: ${desc}, id: ${id}`)
		// let desc = $('#asignatura_'+id).text()
		setAsignaturaToNewSeccion(id, desc)

		$('#btnNewSeccion a').attr('onclick', "$('#newSeccion').modal()")
		$('#btnNewSeccion').show()
	}

	function getSecciones(type, id, controller) {
		$.ajax({
			url: `/coes_dev/secciones/get_tab_objects`,
			data: {id: id, type: type, controlador: controller},
			dataType: 'json', 
			beforeSend: function() {$('#cargando').modal({keyboard: false, show: true, backdrop: 'static'});},
			success: function(data){
				if(data.secciones_length === 0){
					$('#noEncontrado').show();
				}else{
					$('#tableResponse').html(data.th)
					if (type == 'asignatura' && controller == 'inscripcionsecciones'){
						let radios = document.getElementsByClassName(id)
						for (var i=0; i<radios.length; i++)  {
							
							let aux = document.getElementById('tr'+radios[i].id)
							if (aux !== null) radios[i].checked = true
						}
					}

				}
			},
			complete: function(){
				if (type != 'asignatura'){
					paintTabObjects(type,id, controller)
				}

				if (type == 'asignatura'){
					// let desc = $('#asignatura_'+id).text()
					let desc = document.getElementById("asignatura_"+id).firstChild.textContent
					let cred = document.getElementById("bagCreditos"+id).firstChild.textContent
					desc += " ("+cred+" Unidades de Créditos)"
					$('#descAsignatura').html(`${desc}`)
					if (controller == 'secciones') showNewAsig(id)
				}
				$('#responseTotal').show()

				$('.modal').modal('hide')
				$('.tooltip-btn').tooltip()
			}
		});
	}

	function paintTabObjects(type, id,controller, callback){

		let ele = $(`#${type}Tabs`)
		ele.nextAll('.tabs').remove()

		$.ajax({

			url: `/coes_dev/secciones/get_tab_objects`,
			data: {type: type, value: id, controlador: controller},
			dataType: 'json', 
			success: function(data){
				$('#filterTabs').append(data.tabs)
			},
			beforeSend: function(){
				$('#cargando a').html(`Cangando ${type}... `)
				$('#cargando').modal({keyboard: false, show: true, backdrop: 'static'})
			},
			complete: function(){
				$('.modal').modal('hide')
				$('.tooltip-btn').tooltip()
			}

		});
		if (callback) callback()
	}


function setTab(type, id){
	$.ajax({
		url: `/coes_dev/principal_admin/set_tab`, 
		data: {type: type, value: id}, 
		dataType: 'json'
		});
	sessionStorage.setItem(type, id)
}