
### Arquivar Workflow

 Simplificando, quando você *arquiva* um workflow, ele é removido da instância SAP e colocado offline (ou seja, em um arquivo no seu servidor de aplicativos). 
 
 O workflow (e todos os seus itens de trabalho, anexos, histórico de logs etc.) ainda está disponível para acesso somente leitura, mas seus dados desaparecem de muitas tabelas grandes do banco de dados SAP. Isso deixa o pessoal do Basis muito feliz. 
 
 O arquivamento ocorre em duas etapas distintas: gravando um workflow em um arquivo compactado e, em seguida, excluindo o workflow do sistema SAP. Observe que você só pode arquivar workflows com o status CONCLUÍDO (ou CANCELADO). 
 
 Por que você faria isso? Você pode arquivar workflows se:

- Seu sistema de produção está em execução há alguns anos

- Suas tabelas críticas de fluxo de trabalho SAP (como SWWWIHEAD, SWNCNTP0) estão crescendo rapidamente, impactando o desempenho e tornando as tarefas básicas mais lentas
(como backups do sistema)

- Você está migrando para um novo sistema e deseja reduzir a quantidade de dados da tabela do banco de dados

Os riscos são pequenos. Esse procedimento existe há anos e é (presumivelmente) usado rotineiramente por milhares de grandes clientes SAP. Você não "exclui" os workflows até que o processo de "gravação" seja concluído com sucesso. E sim, os workflows são fisicamente excluídos do sistema de produção, mas permanecem em arquivos.

É claro que você precisa ter muito cuidado com esses arquivos; agora é responsabilidade da equipe do Basis mantê-los seguros e com backup adequado.


## Pulos do Gato

SCC1 para transporte customizing de ativação de eventos

Tarefas de etapas de diálogo precisam passar 'Tarefa Geral' para Request Customizing
Programa: RHMOVE30

SAP ALL para usuário que executa em background (WF-BATCH e/ou SAP_WFRT) 

Autorização para SWO_ASYNC 
--> Permite seguir caminho do anexo para visão de um pedido de compra por exemplo.

Transação rmps_set_substitute
--> Dar um substituto a um usuário. Todos os conteúdos da SBWP serão passados.
 
Loop Infinito + SM50 para debugar o método que acontece em background  


## Transações

SWU3 – Customizing Workflow / Configurações RFC

SWDD, PFTC, PFAC – Builder de Workflow/Task 

SWEC, SWE2 – Eventos e Vinculação de Evento

SWDM – Explorer Workflow 

SWPR – Restart de Workflow após erro

SWPC – Restart Workflow após crash no sistema

SWELS, SWEL – Rastreio de Eventos

SWUE – Disparo de Eventos

SWUS – Teste de Workflow

SWUS_WITH_REFERENCE – Iniciar Workflow com Referencia

SWI5 – Inbox do Usuário

SWU_OBUF – Sincronização do Buffer 

SWF_GMP – Visão geral do administrador do WF

SWU7 – Workflow Check para consistência

SWO1 – Builder Business Object (BOR)

SWLO – Exibir workitems do objeto Workflow 

SWWL – Eliminar Workflow 

SWU2 – RFCs presas

SMQA, SM58 – Erros de RFC

SWI2_FREQ, SWI2_DIAG – Análise do Workitem 

SWL1 – Customizing da SBWP

SWIA – Processamento Workflow como Admin 

SWEQADM –  Administrar fila de eventos

RSWWERRE –  Executar monitoramento de erros workflow 

SWW_SARA – Arquivar Workitems

SWDD_SCENARIO, SWDD_SCENARIO_DISP – Workflow flexível


## Funções WAPI
```
CALL FUNCTION 'SAP_WAPI_CREATE_EVENT'

CALL FUNCTION 'SAP_WAPI_START_WORKFLOW'

CALL FUNCTION 'SAP_WAPI_CREATE_WORKLIST'

CALL FUNCTION 'SAP_WAPI_GET_ATTACHMENTS'

CALL FUNCTION 'SAP_WAPI_GET_OBJECTS'

CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'

CALL FUNCTION 'SAP_WAPI_WORKITEM_COMPLETE'

CALL FUNCTION 'SAP_WAPI_DECISION_COMPLETE'

CALL FUNCTION 'SAP_WAPI_READ_CONTAINER'
          
CALL FUNCTION 'SAP_WAPI_WORKITEMS_BY_TASK'

CALL FUNCTION 'SAP_WAPI_GET_WORKITEM_DETAIL'

CALL FUNCTION 'SAP_WAPI_ATTACHMENT_ADD' 

CALL FUNCTION 'SAP_WAPI_ATTACHMENT_DELETE'
```

Exibir Log do WF
```
CALL FUNCTION 'SWL_WI_DISPATCH'
```

Exibir Anexos
```
CALL FUNCTION 'SWL_WI_UPDATE' 
CALL FUNCTION 'SWL_WI_REPLACE'
Principal:
CALL FUNCTION 'SWL_WI_NOTES_DISPLAY'
```

Outras Funções
```
SWW_WI_CONTAINER_DELETE
SWW_WI_OBJECTHANDLE_DELETE
SWW_WI_CONTAINER_INSERT
SWW_WI_CONTAINER_MODIFY
SWW_WI_CONTAINER_MODIFY_CHECK
SWW_WI_CONTAINER_READ
SWW_WI_CONTAINER_READ_OBJECTS
SWW_WI_READ_CONTAINERS_OF_OBJ
SWW_WI_READ_CONTAINERS_OF_OBJS
```

## BADIs Fiori

Apontamento Fiori para BADI - Transação Fiori /n/iwfnd/maint_service

/IWPGW/BADI_TGW_TASK_DATA

/IWWRK/ES_WF_WI_BEFORE_UPD_IB