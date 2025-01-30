
# Questões de Performance

## Introdução

O desempenho de um programa ABAP pode fazer a diferença entre um sistema SAP que funciona de forma eficiente e um que se torna um gargalo para os processos de negócios. 

### 1. Use as Operações Internas Sempre Que Possível
As operações internas, como o uso de tabelas internas, são muito mais rápidas do que operações no banco de dados. Sempre carregue apenas os dados necessários em tabelas internas e manipule-os na memória antes de gravar ou consultar no banco novamente.


### 2. Seleção de Dados Otimizada no Banco de Dados
Evite o uso de SELECT * em suas consultas SQL. Liste explicitamente os campos que você precisa, reduzindo o volume de dados transferidos entre o banco de dados e o sistema.

Exemplo:
```
SELECT matnr, maktx
  FROM mara
  INTO TABLE lt_mara
 WHERE matnr IN @lt_materials.
```


### 3. Utilize o "FOR ALL ENTRIES" com Cuidado
A função FOR ALL ENTRIES é útil, mas pode causar problemas de desempenho se a tabela interna estiver vazia. Sempre verifique se a tabela possui registros antes de usá-la.

Exemplo:
```
IF lt_materials IS NOT INITIAL.
  SELECT matnr, maktx
    FROM mara
    INTO TABLE lt_mara
   FOR ALL ENTRIES IN lt_materials
   WHERE matnr = lt_materials-matnr.
ENDIF.
```

### 4. Evite Loops Aninhados
Loops aninhados podem ser um dos maiores culpados por desempenho ruim. Sempre que possível, utilize READ TABLE com CHAINED KEYS para acessar dados de forma direta.

Exemplo Ruim:
```
LOOP AT lt_materials INTO DATA(material).
  LOOP AT lt_orders INTO DATA(order).
    IF material-matnr = order-matnr." Alguma lógica aqui
    ENDIF.
  ENDLOOP.
ENDLOOP.
```
Exemplo Otimizado:
```
LOOP AT lt_materials INTO DATA(material).
  READ TABLE lt_orders WITH KEY matnr = material-matnr INTO DATA(order).
  IF sy-subrc = 0." Alguma lógica aqui
  ENDIF.
ENDLOOP.
```

### 5. Bufferize Dados Sempre Que Possível
Utilize buffers do SAP (como tabelas bufferizadas) para evitar acessos redundantes ao banco de dados.

Certifique-se de que as tabelas estejam configuradas para bufferização e use SELECT SINGLE para consultas únicas.



### 6. Utilize Field-Symbols para Manipulação de Dados
Field-symbols permitem manipulação direta de dados em memória, reduzindo o overhead associado a cópias de dados.

Exemplo:
```
LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>).
  <fs_mara>-maktx = 'Novo Texto'.
ENDLOOP.
```

### 7. Use Views e CDS Sempre Que Possível
Abuse de Core Data Services (CDS) e Views do SAP para transferir a lógica do ABAP para o banco de dados. Eles permitem uma execução mais eficiente, especialmente em sistemas SAP HANA.


### 8. Evite Excessos no Debug e Logging
O uso de WRITEs ou logs excessivos durante a execução do programa pode degradar o desempenho. Ative logs apenas quando necessário e desative-os em ambientes produtivos.


### 9. Utilize Operadores de Comparação em Lote
Em vez de executar múltiplos IFs ou CASEs, utilize comparações em lote para reduzir o processamento.

Exemplo:
```
IF matnr IN lt_materials.
  " Alguma lógica aqui
ENDIF.
```

### 10. Aproveite o Parallel Processing
Quando trabalhar com grandes volumes de dados, considere o uso de processamento paralelo com ferramentas como a função STARTING NEW TASK para distribuir a carga de trabalho.

Exemplo:
```
CALL FUNCTION 'Z_PROCESS_TASK'
  STARTING NEW TASK lv_taskname
  PERFORMING callback_task_finished ON END OF TASK.
```

## Conclusão
Otimizar o desempenho de códigos ABAP é essencial para garantir que os sistemas SAP funcionem de forma eficaz. Ao aplicar esses truques, você não apenas melhora a performance do sistema, mas também demonstra habilidade técnica e comprometimento com a excelência no desenvolvimento.
