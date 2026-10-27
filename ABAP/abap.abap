
          lv_jobname = 'B2C' && sy-datum && sy-uzeit.
          CALL FUNCTION 'JOB_OPEN'
            EXPORTING
              jobname          = lv_jobname
            IMPORTING
              jobcount         = lv_jobnumber
            EXCEPTIONS
              cant_create_job  = 1
              invalid_job_data = 2
              jobname_missing  = 3
              OTHERS           = 4.


          IF sy-subrc = 0.

            output-mtp_cria_ordem_venda_response-criar_ovresponse-numero_ordem_venda = lc_vbeln.
            output-mtp_cria_ordem_venda_response-criar_ovresponse-status_processamento = 'Sucesso'.
            output-mtp_cria_ordem_venda_response-criar_ovresponse-codigo_mensagem = sy-msgno.
            ls_mensagens-tipo_mensagem      = 'S'. 
            ls_mensagens-codigo_mensagem    = '311'.
            ls_mensagens-descricao_mensagem = 'JOB Criado com sucesso ' && lv_jobname.
            APPEND ls_mensagens TO lw_mensagens.

            READ TABLE lw_itens INTO ls_itens INDEX 1.

            READ TABLE lw_parceiros INTO ls_parceiros WITH KEY tipo_parceiro = 'EO'.

            READ TABLE lw_parceiros INTO ls_parceiros_z8 WITH KEY tipo_parceiro = 'Z8'.

            SUBMIT zrsd_b2c_criarordemdevenda
                    WITH p_motor  = lv_motorista
                    WITH p_ovend  = lc_vbeln
                    WITH p_placa  = lv_placa
                    WITH p_parcei = ls_parceiros-codigo_parceiro
                    WITH p_quant  = ls_itens-quantidade_material
                    WITH p_quantr = ls_itens-qtd_repesagem
                    WITH p_b2cdev = lc_b2cdev
                    WITH p_fatref = ls_order_header_in-ref_doc
                    WITH p_boleto = ls_cabecalho-num_ref_boleto
                    WITH p_cartao = ls_cabecalho-num_doc_aut_cartao
                    WITH p_novcob = lv_vbelndev
                    WITH p_tpdocv = lc_auart
                    WITH p_inter  = abap_true
                    WITH p_prime  = lc_prime             
                    WITH p_parz8 = ls_parceiros_z8-codigo_parceiro
              VIA JOB lv_jobname
                NUMBER lv_jobnumber
              AND RETURN.

            CALL FUNCTION 'JOB_CLOSE'
              EXPORTING
                jobcount             = lv_jobnumber
                jobname              = lv_jobname
                strtimmed            = 'X'
              EXCEPTIONS
                cant_start_immediate = 1
                invalid_startdate    = 2
                jobname_missing      = 3
                job_close_failed     = 4
                job_nosteps          = 5
                job_notex            = 6
                lock_failed          = 7
                OTHERS               = 8.



            