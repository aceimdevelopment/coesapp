module Admin
  class ReportepagosController < ApplicationController
    before_action :filtro_logueado
    before_action :filtro_estudiante
    before_action :set_reportepago, only: [:show, :edit, :update, :destroy]

    # GET /reportepagos
    # GET /reportepagos.json
    def index
      @reportepagos = Reportepago.all
    end

    # GET /reportepagos/1
    # GET /reportepagos/1.json
    def show
    end

    # GET /reportepagos/new
    def new
      @titulo = "Reporte Pago"
      @reportepago = Reportepago.new
      @reportepago.inscripcionescuelaperiodo_id = params[:inscripcionescuelaperiodo_id]
    end

    # GET /reportepagos/1/edit
    def edit
      @titulo = "Editando Reporte de Pago"
    end

    # POST /reportepagos
    # POST /reportepagos.json
    def create
      @reportepago = Reportepago.new(reportepago_params)

      respond_to do |format|
        if @reportepago.save
          flash[:success] = 'Reporte de Pago guardado con éxito'
          format.html { redirect_to principal_estudiante_index_path}
          format.json { render :show, status: :created, location: @reportepago }
        else
          format.html { render :new }
          format.json { render json: @reportepago.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /reportepagos/1
    # PATCH/PUT /reportepagos/1.json
    def update
      respond_to do |format|
        if @reportepago.update(reportepago_params)
          format.html { redirect_to principal_estudiante_index_path, success: 'Reporte de Pago guardado con éxito' }
          format.json { render :show, status: :ok, location: @reportepago }
        else
          format.html { render :edit }
          format.json { render json: @reportepago.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /reportepagos/1
    # DELETE /reportepagos/1.json
    def destroy
      @reportepago.destroy
      respond_to do |format|
        format.html { redirect_to reportepagos_url, notice: 'Reportepago was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_reportepago
        @reportepago = Reportepago.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def reportepago_params
        params.require(:reportepago).permit(:inscripcionescuelaperiodo_id, :numero, :tipo_transaccion, :fecha_transaccion, :respaldo, :banco_origen_id)
      end
  end
end