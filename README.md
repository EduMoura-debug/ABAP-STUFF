# Melhores Práticas ABAP

Uma lista de princípios comuns para um desenvolvimento ABAP limpo.

### Contribuição

Traduzido do original https://github.com/ilyakaznacheev/abap-best-practice/blob/master/README.md

#### Conteúdo

- [Estilo e Diretrizes](#estilo-e-diretrizes) 
    - [Use Pretty-Printer](#use-pretty-printer)
    - [Use Convenções de Nomenclatura](#use-convenções-de-nomeclatura)
    - [Use snake_case](#use-snake_case)
    - [Use ortografia consistente](#use-ortografia-consistente)
    - [Evite declarações obsoletas](#evite-declarações-obsoletas)
- [Codificação](#codificação)
    - [Siga o princípio da separação de preocupações](#Siga-o-princípio-da-separação-de-preocupações)
    - [Escreva código autodescritivo](#escreva-codigo-autodescritivo)
    - [Comente o que você faz, não como você faz](#Comente-o-que-você-faz-não-como-você-faz)
    - [Seja-o-mais-local-possível](#Seja-o-mais-local-possível)
    - [Não use números mágicos](#não-use-números-mágicos)
    - [Evite aninhamento profundo](#evitar-aninhamento-profundo)
    - [Use verificações de código automatizadas](#use-verificações-de-código-automatizadas)
    - [Excluir código morto](#delete-código-morto)
    - [Não ignore os erros](#não-ignore-erros)
    - [Use exceções baseadas em classe](#use-exceções-baseadas-em-classe)
    - [Lidar com exceções o mais rápido possível](#lidar-com-exceções-o-mais-rápido-possível)
    - [Uma classe de exceção por problema, vários textos para diferentes motivos do problema](#uma-classe-de-exceção-por-um-problema-vários-textos-para-diferentes-motivos-de-problemas)
    - [Verifique a acessibilidade do programa](#verifique-a-acessibilidade-do-programa)
    - [Envolva qualquer acesso a dados compartilhado em classes de acesso a dados](#envolva-qualquer-acesso-a-dados-compartilhados-em-classes-de-acesso-a-dados)
    - [Evite declarações de dados implícitas](#evitar-declarações-de-dados-implícitas)
    - [Use tipos e constantes booleanas integradas](#use-tipos-e-constantes-booleanos-integrados)
    - [Não use campos do sistema na UI](#não-use-campos-do-sistema-na-UI)
    - [Use uma categoria adequada de tabela interna](#use-uma-categoria-adequada-de-tabela-interna)
    - [Escolha uma maneira apropriada de acessar uma linha da tabela](#escolha-uma-maneira-apropriada-de-acessar-uma-linha-da-tabela)
    - [Não modifique uma tabela inteira em um loop](#não-modifique-uma-tabela-inteira-em-um-loop)
    - [Sair do processamento com RETURN](#processamento-de-saída-com-retorno)
    - [Não implemente lógica em módulos de diálogo e blocos de eventos](#do-not-implement-logic-in-dialog-modules-and-event-blocks)
    - [Use macros apenas em casos excepcionais](#use-macros-apenas-em-casos-excepcionais)
    - [Faça âncoras para mensagens chamadas implicitamente](#fazer-âncoras-para-mensagens-chamadas-implicitamente)
- [Idioma e Tradução](#idioma-e-tradução)
    - [Não codifique textos](#não-codificar-textos)
    - [Não use constantes de texto](#Não-use-constantes-de-texto)
    - [Use tabelas de texto para armazenamento de texto no banco de dados](#use-tabelas-de-texto-para-armazenamento-de-texto-no-banco-de-dados)
    - [Use o mesmo idioma original para todos os objetos em um projeto](#use-o-mesmo-idioma-original-para-todos-os-objetos-em-um-projeto)
    - [Mantenha a tradução em mente](#mantenha-a-tradução-em-mente)
    - [Use apenas nomes em inglês para objetos de desenvolvimento](#use-apenas-nomes-em-inglês-para-objetos-de-desenvolvimento)
    - [Use apenas textos traduzíveis na IU](#use-apenas-textos-traduzíveis-na-ui)
    - [Use espaços reservados numerados nas mensagens](#use-espaços-reservados-numerados-nas-mensagens)
- [Programação Orientada a Objetos](#programação-orientada-a-objetos)
    - [Use classes em vez de módulos funcionais ou funções sempre que possível](#use-classes-em-vez-de-módulos-funcionais-ou-execute-quando-possível)
    - [Fique SOLID](#permaneça-sólido)
    - [Usar GRASP](#use-agarrar)
    - [Aprenda padrões de design OOP](#Aprenda-padrões-de-design-OOP)
    - [Respeite a Lei de Deméter](#respeite-a-lei-de-deméter)
    - [Evite aulas para ajudantes, utilitários, etc.](#evitar-classes-para-ajudantes-utilitários-etc)
- [Uso de banco de dados](#uso-de-banco-de-dados)
    - [Use OpenSQL sempre que possível](#use-opensql-quando-possível)
    - [Verifique sy-subrc após operações de banco de dados](#check-sy-subrc-after-db-operações)
    - [Leia apenas os campos necessários](#leia-apenas-os-campos-necessários)
    - [Verifique o vazio da tabela FAE](#verifique-vazio-tabela-fae)
- [Performance](#performance)
    - [Não execute SELECT em loops](#não-execute-select-em-loops)
    - [Prefira JOIN a FAE e RANGE](#prefira-join-a-fae-e-range)
    - [Use FAE no HANA](#use-fae-on-hana)
    - [Reduza o número de solicitações de banco de dados](#reduzir-o-número-de-solicitações-de-banco-de-dados)
    - [Crie um perfil do seu código](#perfil-do-código)
- [Teste](#testando)
  - [Testar apenas interface pública](#test-only-interface-pública)
  - [Isole seus testes](#isole-seus-testes)
  - [Mantenha os testes repetíveis](#Mantenha-testes-repetíveis)
  - [Use testes unitários como exemplo de comportamento e documentação](#use-testes-unidades-como-exemplo-e-documentação-de-comportamento)
  - [Lembre-se dos testes ao projetar a arquitetura](#manter-testes-em-mente-ao-projetar-arquitetura)
- [Modelo de programação S/4](#s4-modelo-de-programação)
- [BOPF](#bopf)
  - [Evite acesso direto aos dados do BOPF](#evite-acesso-direto-aos-dados-do-BOPF)
- [Serviços de dados principais](#serviços-de-dados-principais)
  - [Evite lógica de negócios em visualizações CDS](#evite-lógica-de-negócios-em-visualizações-cds)
  - [Evite acesso direto a tabelas de banco de dados e funções de tabela na hierarquia de visualização CDS da camada superior](#evite-acesso-direto-a-tabelas-de-banco-de-dados-e-funções-de-tabela-na-hierarquia-de-visualização-cds-da-camada-superior)


## Estilo e Diretrizes

Abordagens básicas para escrever código limpo e agradável

### Use Pretty-Printer

Configure o Pretty-Printer nas configurações e execute-o sempre que salvar seu código.

Defina as mesmas configurações do Pretty-Printer nas diretrizes do seu projeto para evitar formatações diferentes nos mesmos sistemas.

### Use convenções de nomenclatura

Escolha regras de nomenclatura para cada código ou objeto de dicionário criado. Use-o para evitar confusão.

Além disso, você pode configurar o Code Inspector para verificar a convenção de nomenclatura.

### Use snake_case

Nomeie suas variáveis, métodos, classes, etc. com sublinhados entre palavras como `lo_table_container->get_sorted_table_data()`. É a convenção padrão para ABAP.

[Wikipedia](https://en.wikipedia.org/wiki/Snake_case#Examples_of_languages_that_use_snake_case_as_convention)

### Use ortografia consistente

Existem muitas construções de linguagem alternativas no ABAP, como conjunto de (`=`, `<>`, '>=', etc.) vs. (`EQ', 'NE', 'GE' etc.), declarações de dados, operações, etc.

Escolha uma das alternativas e use-a consistentemente durante o seu desenvolvimento.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenalternative_langu_guidl.htm)

### Evite declarações obsoletas

Algumas declarações no ABAP são obsoletas. Alguns deles estão desatualizados, outros são simplesmente substituídos por novos operandos. Tente evitar declarações obsoletas se existir alguma alternativa mais nova.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenmodern_abap_guidl.htm)

## Codificação

Regras comuns para escrever código melhor em ABAP

### Siga o princípio da Separação das Preocupações

Separe o programa em unidades com mínima sobreposição entre as funções das unidades individuais.

### Escreva código autodescritivo

Um bom código deve explicar-se. Auto-descrever o código não requer tantos comentários ou documentação enorme.

Faça declarações auto-explicativas, por exemplo:

- escolha nomes significativos para variáveis, funções, classes, etc. (`lv_i` → `lv_index`, `lt_data` → `lt_sale_orders`, `cl_util` →`cl_file_io_helper`,`start()` →`run_accounting_document_processing()`)
- agrupar as etapas lógicas em métodos (por exemplo, dividir o método `process_document()` em sequência de métodos `prepare _document_data()`, `is_doc_creation_possible()`, `lock_tables()`, `create_docment()`, `unlock_table()`, etc.)
- reduzir a quantidade de linhas em um bloco de programação 
- diminuir o nível de nidificação 
- evitar a implicação

### Comente o que você faz, não como você faz

Não comente aspectos da implementação, um código autodescritivo fornecerá esta informação para um leitor. Comentário lógica do ponto de vista do processo de negócios, a informação que o leitor não pode extrair do código.

Na melhor das hipóteses, uma breve descrição da unidade de lógica de negócios no cabeçalho do método ou antes da chamada do método será suficiente.

### Seja o mais local possível

Crie variáveis, métodos e atributos com o menor escopo possível. Quanto maior o escopo que a variável/método tem, mais acoplado é o seu programa.

### Não use números mágicos

Evite constantes com código rígido ou variáveis sem nome.

Em vez disso, mova-os em variáveis significativas ou constantes. Observação, que apenas mover texto literal com o mesmo nome não é suficiente (`ABC123` → `lc_abc123`), dê uma descrição adequada (`ABC123` → `lc_storage_class`)

Ruim:
```abap
lo_doc_processor->change_document(
  iv_blart = 'AB'
  iv_bukrs = 'C123'
  iv_popup = lv_x
).
```

Bom:
```abap
CONSTANTS:
  lc_clearing_document TYPE blart VALUE 'AB',
  lc_main_company      TYPE bukrs VALUE 'C123'.
DATA:
  lv_show_popup TYPE abap_bool.
*...
lo_doc_processor->change_document(
  iv_blart = lc_clearing_document
  iv_bukrs = lc_main_company
  iv_popup = lv_show_popup
).
```

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenliterals_guidl.htm)

### Evite Deep Nest

Não escreva loops, casos e outras estruturas de controle. Em vez disso, defina a saída da estrutura de controle com IFs, CHECKs e retornos.

Ruim:
```abap
LOOP AT lt_data ASSIGNING <ls_data>.
  IF a = b.
    IF c = d.
      IF ls_data IS NOT INITIAL.
        ls_data-field = 'aaa'.
      ENDIF.
    ELSE.
      ls_data-field = 'bbb'.
    ENDIF.
  ELSE.
    ls_data-field = 'ccc'.
  ENDIF.
ENDLOOP.
```

Bom:
```abap
LOOP AT lt_data ASSIGNING <ls_data>.
  IF a <> b.
    ls_data-field = 'ccc'.
    CONTINUE.
  ENDIF.

  IF c <> d.
    ls_data-field = 'bbb'.
    CONTINUE.
  ENDIF.

  CHECK ls_data IS NOT INITIAL.
  ls_data-field = 'aaa'.
ENDLOOP.
```

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abennesting_depth_guidl.htm)


### Use verificações de código automatizadas

Use a verificação de sintaxe, verificação estendida do programa e inspetor de código para validar a sua síntese de código, arquitetura, diretrizes, vulnerabilidades e outros aspectos de qualidade.

[Open Source list of checks for SCI/ATC](https://github.com/larshp/abapOpenChecks)

### Excluir o código morto

Remover código antigo e inutilizado. A verificação de sintaxe e a verificação estendida do programa irão ajudá-lo a encontrá-la.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abendead_code_guidl.htm)

### Não ignore erros

Reagir a erros. Pode ser uma mensagem apropriada, ou uma entrada de blog, ou um levantamento de exceção. Mas não os ignore, caso contrário, você não vai encontrar a causa de qualquer problema.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenreaction_error_guidl.htm)

### Use exceções baseadas em classes

Existem vários tipos históricos de erro no ABAP - excepções de sistema, excepções clássicas e excepções baseadas em classes. As excepções do sistema não são permitidas, as excepções clássicas são explícitas e desatualizadas. Não há razão para usar excepções baseadas em classes.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenclass_exception_guidl.htm)

### Gerencie excepções o mais rápido possível

Melhor lidar com a exceção mais perto da pilha de chamadas para a cláusula de elevação. Gerencie-o quando o contexto do nível de pilha atual tiver informações suficientes para o manuseio adequado.

### Uma classe de exceção por um problema, vários textos por diferentes razões de problema

Não crie muitas classes diferentes para cada cláusula de elevação. Em vez disso, crie uma classe para um tipo de problema, ou seja, para um único tipo de gerenciamento de problemas.

Criar mensagens significativas que descrevam cada razão para este tipo de problema. O tratamento de erros pode ser o mesmo, mas as razões, o registo e a notificação do usuário serão diferentes.

Exemplo: você está lendo um arquivo do PC. Pode haver um problema diferente - o arquivo está corrompido, o ficheiro está vazio, o acesso é negado, etc. Mas se você só quer saber, se o arquivo foi carregado com sucesso, uma classe de exceção `zcl_io_error` será suficiente. Mas crie mensagens apropriadas para cada motivo de erro ou tipo de error para deixar o usuário saber, *por que * exatamente o arquivo não foi carregado.

### Verifique a acessibilidade do programa

Certifique-se de que o seu aplicativo pode ser usado por pessoas com deficiência. Significa que qualquer informação sobre a interface de usuário deve ser dada em uma forma acessível:

- os campos de entrada e de saída devem ter rótulos significativos; 
- os ícones devem ter uma dica de ferramenta; 
- as colunas da tabela devem ter um cabeçalho; 
- a informação não deve ser expressa apenas pela cor;

Isso garante que as pessoas com deficiências como cegueira de cores ou usuários de leitor de tela terão acesso total à funcionalidade da aplicação.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenaccessibility_guidl.htm)

### Embrulhe qualquer acesso de dados compartilhados em classes de acesso a dados

Quando você usa alguns dados compartilhados, como memória compartilhada, objetos compartilhadas, tampões, etc., não aceda a eles diretamente. Em vez disso, envolva-os em métodos setter e getter da classe de acesso de dados estáticos.

Ele irá ajudá-lo a controlar o acesso aos dados compartilhados e encontrar facilmente quaisquer alterações de dados partilhados através da lista onde usados. Ele também lhe permitirá mimetizar o acesso de dados compartilhados em testes de unidade.

### Avoid implicit data declarations

Sempre que possível, tente não usar declarações de dados como `TABLES`, `NODES`. Eles criam objetos de dados com acesso implícito.

Ao invés disso, use `DATA`. Apenas use `NODES` com LDB. Ambos criam work areas globais que serão compartilhadas e usadas atráves de todos os programas.

Nunca use `TABLE ... WITH HEADER LINE`. Use qualquer estrutura, field-symbol ou referência com o tipo de linha de tabela ou declaração inline e expressões de tabela.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abentable_work_area_guidl.htm)

### Use tipos e constantes booleanos incorporados

Quando você quiser usar algumas informações lógicas, use o tipo booleano embutido `abap_bool` em vez de `char1` ou outros tipos.

Use as constantes `abap_true` e `abap_false` para valores booleanos verdadeiros e falsos. Não use letras como `'X'`, `' '` - é um código rígido.

O uso de `espaço`', `IS INITIAL` ou `IS NOT INICIAL` também não é aconselhável, porque eles verificam o estado de implementação técnica de `abap_bool`, mas não o sentido do objeto de dados Boolean real.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abendataobjects_true_value_guidl.htm)

### Não usar os campos do sistema na interface

Os campos do sistema (sy) são técnicos. Eles não devem ser mostrados ao usuário.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenuse_ui_guidl.htm)

### Use uma categoria adequada da tabela interna

Seleccione uma categoria de tabela adequada. Para tabelas pequenas, os índices ou as chaves hash podem ser redundantes, mas para tabelas grandes, use sempre a seguinte regra:

- acessos de índice: tabela padrão
- acesso de índice e acesso de chave: tabela ordenada
- Acesso apenas à chave: tabelas hashed

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenselect_table_type_guidl.htm)

### Escolha uma maneira apropriada de acessar uma linha de tabela

Existem três maneiras de armazenar uma linha acessada de uma tabela interna enquanto lê - `INTO` copia a linha em estrutura, `ASSIGNING` atribui a linha ao símbolo de campo e `REFERENCE INTO` cria uma referência à linha. O mesmo se aplica às expressões de tabela, mas um tipo de armazenamento de linha é escolhido pela categoria do resultado.

A regra é:
- usar uma área de trabalho (estrutura) se o tipo de linha é estreito e a linha de leitura não deve ser modificada.
- use o símbolo de campo se o tipo de linha é largo ou profundo e a linha de leitura deve ser modificada.
- use referência se o tipo de linha é largo ou profundo e uma referência à linha de leitura deve ser passada.

Em razão de desempenho é melhor evitar a cópia de linha em loops.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abentable_output_guidl.htm)

### Não modificar uma tabela inteira em um loop

Ao percorrer uma tabela interna, não execute declarações que alterem todo o corpo da tabela. Apenas modificar a tabela em fila, ou seja, linha-a-linha.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenloop_guidl.htm)

### Exit processing with RETURN

Apenas use `RETURN` para sair do método, funcão, form, etc. Nunca use `CHECK` or `EXIT`.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenexit_procedure_guidl.htm)

### Não implementar lógica em módulos de diálogo e blocos de eventos

Em vez disso, chame o método de classe relevante, que encapsula a implementação lógica.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abendial_mod_event_block_guidl.htm)

### Usar macros apenas em casos excepcionais

Evite o uso de macros sempre que possível. A macro tem várias desvantagens:

- não é capaz de depurar; 
- não há verificação de sintaxe; 
- interface de chamada implícita 
- nenhuma verificação do tipo de parâmetros da interface.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenmacros_guidl.htm)

### Faça âncoras para mensagens implicitamente chamadas

Quando você passar atributos de mensagem (classe, número, argumentos) implicitamente, por exemplo, por função ou chamada de método, ou usando variáveis, use âncoras para permitir que a mensagem seja pesquisável dentro de uma lista onde usada.

Pode ser feito da seguinte maneira (como é feito em um padrão):

```abap
IF 1 = 2. MESSAGE i123(abc) ... . ENDIF.
```

ou

```abap
MESSAGE i123(abc) ... INTO sy-msgli. "depois use os campos sy-msg* para passar os atibutos da messagem
```

## Língua e Tradução

Como preparar o aplicativo para internacionalização e localização

### Não escreva textos de código rígido

Nunca escreva textos como letras de texto inline - eles são difíceis de encontrar e não é possível traduzir. Use a classe da mensagem ou o símbolo de texto em vez disso. 

### Não usar constantes de texto

Não usar constantes para armazenar texto (unless it is not text but a char constant). As constantes de texto não podem ser traduzidas. Use a classe da mensagem ou o símbolo de texto em vez disso.

### Usar tabelas de texto para armazenamento de texto em DB

Não armazene textos nas mesmas tabelas do dicionário que outros dados. Criar tabelas de texto e as atribuir à tabela principal através de uma chave estrangeira. Existem algumas vantagens das tabelas de texto:

- Eles suportam a tradução; - Vários textos podem ser tratados para o mesmo objeto (por exemplo, texto curto, médio, longo, etc.); 
- Não é necessária nenhuma ajuda de pesquisa. Os textos da tabela de texto serão automaticamente adicionados a uma lista de valores; 
- Não é necessária manutenção adicional. Coluna de texto será adicionada automaticamente a uma vista de manutenção; 
- As traduções podem ser feitas com a transação `SE63`.

### Use a mesma linguagem original para todos os objetos em um projeto

Escolha uma língua e use-a como origem ao criar novos objetos. Será mais fácil de manter e traduzir no futuro.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenoriginal_langu_guidl.htm)

### Mantenha a tradução em mente

Lembre-se que todos os textos, mensagens, nomes, etc. podem ser traduzidos. As frases terão um comprimento diferente (ou mesmo uma justificação diferente) em diferentes idiomas. Deixe algum espaço livre para ele.

*As frases em inglês são muito mais curtas, do que outras línguas mais usadas.*

### Use apenas nomes em inglês para objetos de desenvolvimento

Quando você nomeia alguns objetos de programação, como variáveis, métodos ou nomes de classes, ou objetos do dicionário, como tipos, estruturas, tabelas, etc., use apenas nomes em inglês. 

Não use outras línguas, não as combine. Inglês é compreensível na maioria dos países, é útil e educado fazer seu código internacional. Talvez seja apoiado por outra equipe de outro país.

E é apenas um padrão e uma melhor prática em um mundo de programação. Não seja um bárbaro.

### Use apenas textos tradutíveis na interface

Enviar ao usuário apenas textos tradutíveis, como mensagens, OTRs, símbolos de texto, etc.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abensystem_text_guidl.htm)

### Usar detentores de lugar numerados em mensagens

Use detentores de lugares numerados `&1` - `&4` em vez de detentoras de lugares anônimos `&`. A ordem das palavras inseridas pode diferir em diferentes idiomas. Um tradutor pode precisar de alterar a ordem dos textos de substituição ao traduzir textos de mensagens. Com detentores de lugares anônimos, isso não é possível.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abentrans_relevant_text_guidl.htm)

## Programação Orientada a Objetos

Aqui estão algumas boas práticas de OOP, não só específicas de SAP, mas também práticas comuns

### Use classes em vez de módulos funcionais ou executa quando possível

*SAP postula que o uso de módulos de código não-objeto-orientado é obsoleto.*
Usar FMs apenas onde não há possibilidade de usar classes (e.g. RFC, update modules, etc.)

ABAP é uma linguagem de programação empresarial, e OOP pode melhor do que outros descrever processos de negócios complicados.

Além disso, todas as novas tecnologias SAP são baseadas em classes.

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenabap_obj_progr_model_guidl.htm)

### Fique SOLID

Use princípios SOLID no desenvolvimento de OOP. Aqui estão cinco princípios fundamentais de um desenvolvimento de software flexível e extensível:

- [**S**ingle responsibility principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)
- [**O**pen/closed principle](https://en.wikipedia.org/wiki/Open/closed_principle)
- [**L**iskov substitution principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle)
- [**I**nterface segregation principle](https://en.wikipedia.org/wiki/Interface_segregation_principle)
- [**D**ependency inversion principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle)

### Use GRASP

Este é um conjunto de padrões e princípios para atribuir responsabilidade a classes e objetos no design orientado a objetos.

Não existem apenas padrões de comportamento úteis, mas também princípios muito importantes como "baixo acoplamento" e "alta coesão".

[Wikipedia](https://en.wikipedia.org/wiki/GRASP_(object-oriented_design))

### Aprenda padrões de design OOP

Existe um conjunto de padrões de design OOP clássicos bem conhecidos, que são muito úteis no desenvolvimento empresarial. Se você os conhece, você pode facilmente compartilhar ideias de design com a equipe, resolver desafios de arquitetura mais rapidamente e encontrar melhores soluções de problemas.

Respeite a Lei de Demeter

- cada unidade deve ter apenas conhecimento limitado sobre outras unidades: apenas unidades "preto" relacionadas com a unidade actual; 
- Cada unidade só deve falar com seus amigos; Não fale com estranhos; 
- fale apenas com seus amigos imediatos.

Isso significa que, se a classe A tem acesso à classe B, e B, por sua vez, tem acesso a classe C, a classes A não deveriam ser capazes de chamar um método de C diretamente como `A->B->C->method_of_C()`. B tem de ter um método especial para isso.

Por exemplo, se quisermos que um cão barbeie, não chamaremos `lc_dog->get_head()-> get_voice_functions()-)->run_bark_sound()`, mas ` lc_ dog->bark()`.

[Wikipedia](https://en.wikipedia.org/wiki/Law_of_Demeter)

### Evite aulas para ajudantes, utilitários, etc.

Existem muitos casos no desenvolvimento de ABAP quando algum método de utilidade pode ser necessário. Mas em vez de métodos estáticos transformá-los em objetos poderosos. Pense na função como uma classe, que é responsável por fazer este tipo de operações. Por exemplo, em vez de utilitário para carregar a tabela do Excel na tabela de cordas, crie uma classe que carregue uma tabela Excel no construtor e seja capaz de lhe dar em qualquer forma que você queira (even as a string table). 

Você pode ir em frente e criar uma interface para formatação de dados de tabela e implementá-lo para várias faixas de tabelas - Excel, CSV, XML, etc. Ou definir uma interface de leitor de tabelas como um parâmetro de construtor de formatação de tabela, e implementá-lo para diferentes tipos de carregamentos de dados.

Em qualquer caso, será mais flexível e mais útil como apenas um método estático.

Por exemplo:

- `lt_str = cl_file_util=>upload_file_into_str_tab( lv_path )` → `lt_str = NEW cl_file( path )->get_str_tab( )`
- `lv_date = cl_format_util=>format_date_to_gmt( sy-datum )` → `lv_date = NEW cl_date_formatter( sy-datum )->get_gmt( )`

## Uso da Base de Dados

Como criar solicitações de DB eficientes

### Use OpenSQL enquanto possível

Use o OpenSQL (ABAP SQL desde 7.53) em vez do Native SQL.
Tem várias vantagens:

- Verificação de sintaxe; - verificação de validação; - Interpretação cross-server; - Sintaxe comum; - Integração com ABAP.

Principais causas do uso do NativeSQL: problemas de desempenho, funções específicas do DB. 

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abendatabase_access_guidl.htm)

### Verifique o sy-subrc após as operações do DB

Verifique explicitamente o estado da operação do DB, verificando `sy-subrc`.

Mesmo que você não tenha nenhum gerenciamento de erros, coloque a verificação `sy-subrc` para torná-lo explícito e deixe alguém saber, que o gerenciar de erro não requer.

```abap
IF sy-subrc <> 0. 
  * nothing to do
ENDIF 
```

[SAP Help](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abenreturn_value_guidl.htm)

### Leia apenas os campos que você precisa

Evite `SELECT *` no seu código. Existem várias razões:

- Quantos campos você pegar, quanto mais tempo leva e quanto mais capacidade de canal DB ele usa. A leitura de campos desnecessários é ruim por razões de desempenho; 
- O esquema da tabela do banco de dados pode mudar no futuro. Se você esquecer de adaptar seu programa (e provavelmente irá, porque o esquema da tabela pode ser alterado por outra pessoa), você irá ler campos, que não são necessários para seu programa.

Excepção: Consumo CDS vistas, que são únicos e projetados para um determinado caso de uso, então eles provavelmente consistirão apenas de campos necessários.

### Verifique o vazio da tabela FAE

Verifique sempre se a tabela, que você está prestes a usar na declaração `FOR ALL ENTRIES`, não está vazia.

Caso contrário, `SELECT` devolverá **cada entrada** que a tabela de banco de dados contém ignorando outras condições de `WHERE`.

Ou seja, se a sua tabela de banco de dados contém entradas de 1K e a sua cláusula `WHERE` corta o número para 10, se a tabela na FAE estiver vazia, a selecção irá obter entradas 1K.

## Performance

Use estas regras para evitar problemas de desempenho

### Não execute SELECT em loops

Tente evitar operações de DB em loops como `DO-ENDDO`, `WHILE-ENDWILE`, `LOOP-ENDLOOP`, `PROVIDE-ENDPROVIDE` e `SELECT-ENDSELECT`.

Em vez disso, extraia critérios de operação do loop e execute a operação DB **once**.

Pode ser difícil, do ponto de vista da arquitetura, desconectar as operações do DB dos loop. Para resolver este problema, você pode usar o padrão Data Access Class (DAC) para encapsular todas as operações do DB em alguma classe (ou conjunto de classes) e executar operações DB o mínimo possível (e.g. before loop or after loop using lazy load). Em seguida, execute uma leitura regular em um loop, mas a partir da tabela interna encapsulada em DAC, não a partir de DB.

### Prefira JOIN sobre FAE e RANGE

As operações de junção são muito mais rápidas porque não têm muitas entradas (sem transferência adicional da Aplicação para o DB) e o mapeamento de campo (`ON` parte do seu `SELECT`) é realizado usando estruturas de DB internas (no additional conversion needed).

### Use FAE on HANA

FAE (`FOR ALL ENTRIES`) is still relevant on HANA. Make sure to update your DB to the latest available patch level and use FDA (Fast Data Access). FDA operations are 10x to 100x times faster than conventional FAE.

[2399993 - FAQ: SAP HANA Fast Data Access (FDA)](https://launchpad.support.sap.com/#/notes/2399993)

### Reduz o número de solicitações de DB

Tente organizar o seu código de forma a executar o mínimo possível de solicitações de DB. O acesso ao DB é frequentemente um obstáculo, e um número de sessões do DB é limitado. Tente manter o desempenho em mente e agrupar pedidos semelhantes juntos. 

Obter 10 linhas uma vez em vez de 10 solicitações para cada linha. Pode ser necessário alterar uma arquitetura de programa, por exemplo, para calcular as chaves de solicitação antes de usar os resultados.

### Profile o seu código

Faça o perfil de seu código quando você escrever algo mais complicado, do que um relatório de lista. Use `ST05`, `SAT` ou qualquer outra ferramenta de perfil que você precise para garantir que seu código não tenha problemas de engarrafamento e desempenho.

## Testes

Como verificar a qualidade do seu código

### Teste apenas a interface pública

No teste de unidade, você não deve testar qualquer implementação interna da classe, por exemplo, métodos privados e protegidos.

Teste apenas métodos públicos, ele irá simular a forma como o programa usa a classe na "vida real". Todos os métodos internos serão chamados a partir de métodos públicos de qualquer maneira. Se não - o método não é realmente usado na aula e deve ser removido.

O teste deve verificar o comportamento da classe, não sua implementação. Você pode refactor ou alterar a implementação, mas o teste será o mesmo. Se o comportamento da classe não mudar, nenhuma mudança necessária no teste também.

Deixe qualquer lógica interna encapsulada testando apenas métodos públicos.

### Isole seus testes

Os testes não devem afetar um ao outro. Cada teste deve ser executado separadamente em ambientes isolados - por exemplo, você deve limpar o ambiente antes ou depois de uma corrida de teste. 

### Mantenha os testes repetíveis

A mesma entrada de teste deve dar a mesma saída, os valores reais devem atender às expectativas, o comportamento do teste deve ser repetível.

### Use testes de unidade como exemplo de comportamento e documentação

Um teste de unidade mostra como um módulo de programa deve funcionar. Se você testá-lo da mesma maneira, como é usado em um programa real, será a melhor documentação (com exemplos!) para um desenvolvedor.

### Mantenha os testes em mente ao projetar a arquitetura

Apenas programas bem projetados podem ser facilmente testados. Para facilitar o teste de unidades, faça com que os seus módulos possam ser testados de forma independente. Fazê-los baixos acoplados e altamente coesivos, remova relações desnecessárias, use injeção de dependência, esconda classes dependentes atrás de interfaces para ridicularizá-las em testes. SoC, SOLID, GRASP são seus amigos.

## S/4 Modelo de Programação

*A fazer*

## BOPF

Como usar o Business Object Processing Framework da maneira correta

### Evite acesso direto aos dados do BOPF

Não execute operações DB diretas em tabelas BOPF. O BOPF encapsula diferentes operações, tais como buffering, validações de dados, cálculos de dados etc. que serão desencadeados apenas na chamada da API do BOPФ. O acesso direto pode causar erros no processo de trabalho do BOPF.

## Serviços de dados principais

Como não se perder na hierarquia CDS

### Evite lógica de negócios em visualizações CDS

Tente usar o CDS Views apenas para modelagem de dados. 

Se você adicionar algumas condições ou regras relacionadas a negócios, elas provavelmente precisarão de atualizações frequentes, que podem quebrar programas, que usam essas vistas do CDS, e testes de unidade. Mudanças nas Visualizações do CDS também podem influenciar as Visões de CDS superiores de forma implícita.

Use CDS Views apenas como modelos de dados e separar a lógica de negócios correspondente em programas ABAP ou objetos de negócio.

### Evite acesso direto a tabelas de banco de dados e funções de tabela na hierarquia de visualização CDS da camada superior

Para cada tabela de banco de dados, deve ser criada uma visualização de base de dados ou uma função de tabela correspondente à Visualização Básica do CDS. Essas vistas descrevem nomes significativos para campos de tabelas de banco de dados, adicionam associações e anotações específicas de dados.

Por exemplo, uma vista `I_Material` para a tabela `MARA`.

Use Basic Views em vez de acesso direto a tabelas de banco de dados em Visualização de CDS. Criar a Visualização Básica do CDS quando você criar uma nova tabela de banco de dados e quiser acessar seus dados no CDS.
