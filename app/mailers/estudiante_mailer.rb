
class EstudianteMailer < ActionMailer::Base
    
  default from: "COES-FHE <controlestfheucv@gmail.com>"#, authentication: 'plain'
  layout 'mailer'
  def ratificacionEIM201902A(estudiante)
    @nombre = estudiante.usuario.nombres
    @genero = estudiante.usuario.genero
    usuario = estudiante.usuario
    @ratifiacadas = estudiante.inscripciones.del_periodo('2019-02A').ratificados if estudiante
    mail(to: usuario.email, subject: "Confirmación Proceso de Inscripción Idiomas Modernos 2019-02A")
  end

  def preinscrito(usuario, inscripcionperiodo)
    @asignaturas = inscripcionperiodo.inscripcionsecciones.map { |ins| ins.asignatura}
    @escuela_desc = inscripcionperiodo.escuela.descripcion
    @periodo_id = inscripcionperiodo.periodo.id
    @nombre = usuario.primer_nombre_apellido
    @genero = usuario.genero
    mail(to: usuario.email, subject: "¡Preinscripción Exitosa en #{@escuela_desc} para el Período #{@periodo_id} COES-FHE! ")    
  end

  def confirmado(usuario, inscripcionperiodo)
    @asignaturas = inscripcionperiodo.inscripcionsecciones.map { |ins| ins.asignatura}
    @escuela_desc = inscripcionperiodo.escuela.descripcion
    @periodo_id = inscripcionperiodo.periodo.id
    @nombre = usuario.primer_nombre_apellido
    @genero = usuario.genero
    mail(to: usuario.email, subject: "¡Confirmación de Asignaturas en #{@escuela_desc} para el Período #{@periodo_id} COES-FHE!")
  end

  def bienvenida(usuario)
    @monto = "Bs. 1.500.000."
    

    @nombre = usuario.primer_nombre_apellido
    @genero = usuario.genero
    mail(to: usuario.email, subject: "¡Bienvenidos a COES-FHE!")
  end


end
