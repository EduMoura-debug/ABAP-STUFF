# CDS Overview

## 1 - CDS Model

Os modelos de CDS compreendem as definições de várias tipos de entidades CDS, como visualizações de CDS e entidades abstratas de CDS

Existem diferentes tipos de modelos de visualização CDS

### Views (Também conhecidas como visualizações V1):

• Representam os modelos de visualização CDS originais. 

### Entity Views (Também conhecidas como visualizações V2):

• Representam o sucessor das visualizações V1. Mais possibilidades.
• Em comparação com as visualizações V1, as visualizações V2 não geram uma visualização adicional do ABAP Data Dictionary em sua ação.
• Isso reduz o risco de inconsistências técnicas e melhora o
desempenho geral de ativação.
• Além disso, as visões V2 reforçam mais a modelagem homogênea e aplica verificações de sintaxe mais rigorosas.

### Projection Views:

• Representam uma especialização das entidades de visualização. Seu principal objetivo é a definição de interfaces em seus modelos de CDS subjacentes com um mapeamento modelado da funcionalidade correspondente. Como resultado, as visualizações de projeção restringem a funcionalidade geral das entidades de visualização a meros recursos de projeção. 
• Projeção de uma entidade, de uma composite. Limita a um objeto final, sendo a última camada para expansão de Annottations.

### Transient Views (às vezes também referidas como visualizações V3):

• Definem entidades de visualização CDS sem uma representação direta no sistema de banco de dados SAP HANA.
• Eles atuam como meros modelos de visualização declarativos cujo comportamento em tempo de execução é governado e implementado por componentes de infraestrutura, como o mecanismo analítico.
• Isso implica que você não pode usar visualizações transitórias como fontes de dados para outras visualizações CDS, nem pode selecionar em seu código ABAP.
• Você aprenderá sobre o uso de visualizações transitórias no contexto da implementação de consultas analíticas

## 2 - Sintaxe

As visualizações de CDS definem instruções de seleção, que são aumentadas com informações adicionais de metadados.

```java
/*comentário bloco*/ //comentário comum
//annotations
@AccessControl.authorizationCheck: #MANDATORY //Autenticação de autorizações
@EndUserText.label: 'View Definition' 
//view definition
define view entity Z_ViewDefinition 
   // parameter definition
   with parameters 
     P_SalesOrderType: auart
    //data source of selection with alias name 
    as select from ZI_SalesOrderItem as ITEM
    //join
    left outer to exact one join ZI_SalesOrder as SO 
        on SO.SalesOrder = ITEM. SalesOrder
    //definição de associação
    association [0..1] to ZI_Product as Product on 
        $projection.RenamedProduct = _Product.Product
{
    //projected field as key
    key ITEM.SalesOrder,
    //projected field used in association definition
    key ITEM.Product as RenamedProduct,
    //constante
    abap.char'A' as Constant,
    //calculated field
    concat( ITEM. SalesOrder, ITEM. Product) as CalculatedField,
    //aggregate
    count(*) as NumberOfAggregatedItems,
    //projected association
    ITEM. SalesOrder,
    //association exposure
    _Product
}

//filter conditions based on join partner and parameter 
where
    So.SalesOrderType = $parameters.P_SalesOrderType 
    //aggregation level
group by
    ITEM. SalesOrder,
    ITEM.Product

```

### Campos Chave (Key Fields)

Os campos de visualização do CDS são definidos como campos-chave, adicionando a chave de elemento de sintaxe anterior aos campos. 

Em geral, uma chave do modelo CDS pode ser composta de vários campos chaves. Estes devem ser colocados antes dos campos-não-chave na lista de projeção de visualização do CDS. Além disso, key fields podem ser usados para verificações de consistência (cardinalidade, associações).

Recomenda-se manter a chave mais curta possível. Somente utilize o que você precise.

```java
define view entity ZZI_DLCDS_ORD_IT
  as select from zzdlcdst_ord_it
{
  key sales_order       as SalesOrder,     // Campo-Chave
  key sales_order_item  as SalesOrderItem, // Campo-Chave
      product           as Product,        // Não precisa ser Campo-Chave
}
```

Campos-chave também tem impacto no controle de acesso da CDS, que avaliam as principais definições ao injetar restrições de autorização em instruções selecionadas. São avaliadas por várias estruturas de implementação, que fornecem seus serviços em cima da visualização (herança de chaves).

### Tipos Literais

Os tipos literais permitem que você especifique o tipo técnico ABAP de um valor constante, que você introduz no seu modelo CDS. São campos que não pertencem a fonte.

Para fazer com que um literal simples se torne um literal digitado, você precisa incluir o valor real em marcas de cota únicas e adicionar as informações do tipo como um prefixo.

```java
define view entity Z_ViewWithTypedLiterals
  as select distinct from t000
{
  'Char10'                              as CharacterValue,
  cast( 'Char10' as abap.char(10) )     as CastCharacterValue,
  abap.char 'Char10'                    as TypedCharacterValue,
  cast( abap.char 'Char10' 
        as Char10 preserving type )     as CastTypedCharacterValue,

  1234.56                               as FloatingPointValue,
  abap.fltp'1234.56'                    as TypedFloatingPointValue,
  fltp_to_dec(1234.56 as abap.dec(6,2)) as ConvertedDecimalValue,
  abap.dec'1234.56'                     as TypedDecimalValue,
  abap.dec'001234.5600'                 as TypedDecimalValue2
}
```

### Tipos Simples

Tipos elementares que podem ser utilizados na sua CDS.

```java
@EndUserText.label: 'Teste' 
define type ZGFD_TYPE_CDS_1: abap.lang
```

Tipos podem ter uma hierarquia também, são conhecidos como tipos de multinível.

Dentro da sua CDS, o uso dos tipos simples servem para tipar os campos da View. Além disso, facilitam na modelagem de dados e manutenção de aplicações.

### Condições (Case statement)

Instruções case são usadas para definir cálculos condicionais dentro da sua CDS. Possível definir vários caminhos com os comandos *when-then* e no final da declaração, para exclusão, o *else*.

```java
case (SalesOrderType)
    when 'TAF' then 'X'
    when 'OAF' then 'X'
    //when SalesOrderType = 'OAF' then 'X'
    //when SalesOrderType = 'TAF' or SalesOrderType = 'OAF' then 'X'
    else ''
end

// utilizando cast
cast(
    case
        when 'TAF' then 'X'
        when 'OAF' then 'X'
        else '' end as abap.char(1) ) as CastVar

```

### Varíaveis de sessão 

Informações da sessão de tempo de execução da CDS. Funciona como o "sy" do abap clássico. 

*$session.client*
*$session.system_date*
*$session.system_language*
*$session.user*
*$session.user_date*
*$session.user_timezone*

## 3 - Seleções e Busca de dados

### Select Distinct

Ao aplicar a intrução select distinct, é possível remover registros duplicados da lista de resultados de seleção. A comparação considera todos os campos solicitados.

```java
define view entity Z_View
   as select from t000`{
    abap.char'A' as Campo1

   }

define view entity Z_View2
   as select distinct from t000`{
    abap.char'A' as Campo1

   }
```

Normalmente são usadas como ajudas de pesquisa em CDS. Mas em geral, elas removem a duplicidade em uma CDS.

### Union Definitions

As Union Views combinam e unificam registros de dados em diferentes fontes de dados.

São definidas pela combinação de múltiplos Selects. Itens combinados devem ter o mesmo tipo, podem ser diferentes porém conversíveis. Além disso, anotações de elementos não devem ser propagadas para a union view (uso de *@Metadata.ignorePropagatedAnnotations: true*).

```java
@Metadata.ignorePropagatedAnnotations: true

define view entity Z_UnionView
  as select from Z_ViewAsDataSourceA
    association [0..1] to Z_ViewAsDataSourceC as _ViewC on 
    $projection.UnionField1 = _ViewC.FieldC1
{
    @EndUserText.label: 'Label of UnionField1'
    key FieldA1 as UnionField1,
    key FieldA2 as UnionField2,
    key FieldA3 as UnionField3,
        _ViewC
}

union select from Z_ViewAsDataSourceB
  association [0..1] to Z_ViewAsDataSourceC as _ViewC on 
  $projection.UnionField1 = _ViewC.FieldC1
{
    key FieldB2 as UnionField1,
    key FieldB1 as UnionField2,
    key ''      as UnionField3,
        _ViewC
}
```

Utilização do Union garante o *distinct*, apenas uma linha única, sem dados duplicados. Para reter os registros duplicados, é possível a lógica UNION ALL.

```java
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_UnionView
  as select from Z_ViewAsDataSourceA
{
    FieldA1
}

union ALL select from Z_ViewAsDataSourceA
{
    FieldA1
}
```

### Intersect e Except

Esses dois comandos são usados para definir interseções e exceções entre duas fontes de dados.

**Intersect**: Identificar registros que são comuns a duas fontes de dados distintas. Utilizada para obter a interseção das fontes.

**Except**: Identificar registros que estão presentes apenas em uma das duas fontes de dados. Utilizada para excluir registros de uma fonte de dados que estão presentes em uma fonte. 

### Joins

Joins permitem modelar links condicionais entre duas fontes de dados. Suas condições descrevem os critérios para vincular um registro de dados da fonte de dados secundária. 

**Left Outer Joins**:
  Relacionam registros de uma fonte de dados primária com registros de uma fonte de dados secundária.
  O resultado contém todos os registros da fonte de dados primária.

**Right Outer Joins**:
  Relacionam registros da fonte de dados secundária com registros da fonte de dados primária.
  O resultado contém todos os registros da fonte de dados secundária.

**Inner Joins**:
  Relacionam registros de uma fonte de dados primária com registros de uma fonte de dados secundária.
  O resultado contém apenas os registros da fonte primária que têm pelo menos um parceiro na fonte secundária.

**Cross Joins**:
  Combinam todos os registros de uma fonte de dados primária com todos os registros de uma fonte de dados secundária. 
  O número de registros no resultado é igual ao número de registros da fonte primária multiplicado pelo número de registros da fonte secundária.

### Funções de Agregação SQL 

Permitem realizar cálculos de agregados predefinidos de forma eficiente no banco de dados.

Exemplos: *group by*, *max()*, *min()*, *sum()*, *count()*, *avg()*.

```java
define view entity Z_ViewWithAggregations
  as select from Z_ViewAsDataSourceF
{
  key Field1,
  min(Field3)                                 as FieldWithMin,
  max(Field3)                                 as FieldWithMax,
  avg(Field3 as abap.decfloat34)              as FieldWithAvg,
  cast(sum(Field3) as abap.int4)              as FieldWithSum,
  count(distinct Field1)                      as FieldWithCountDistinct,
  count(*)                                    as FieldWithCountAll
}
group by Field1
```

- **min(Field3) as FieldWithMin**

Retorna o menor valor de Field3 para cada Field1.

- **max(Field3) as FieldWithMax**

Retorna o maior valor de Field3 para cada Field1.

- **avg(Field3 as abap.decfloat34) as FieldWithAvg**

Calcula a média de Field3, convertendo os valores para decfloat34 antes da média. Isso garante maior precisão nos cálculos.

- **cast(sum(Field3) as abap.int4) as FieldWithSum**

Soma todos os valores de Field3 e depois converte o resultado para o tipo int4 (inteiro de 4 bytes).

- **count(distinct Field1) as FieldWithCountDistinct**

Conta quantos valores distintos de Field1 existem por agrupamento. Pode ser útil quando Field1 aparece repetido e você quer saber quantos únicos há.

- **count(*) as FieldWithCountAll**

Conta todas as linhas do agrupamento (incluindo valores repetidos).É o total de registros para cada valor de Field1.

- **group by Field1**
O agrupamento é feito por Field1, ou seja, todos os cálculos acima são feitos por grupo de Field1.

### Campos de projeção (Porjection Fields)

Definidos na lista de seleção de uma CDS. Dentro da definição de visualização da CDS, você pode acessar esses campos prefixando seus nomes com o operador:
```java
$projection.NomeCampo
```

Você pode usar campos de projeção para se referir aos resultados de cálculos definidos na view. Podemos usar campos de projeção também para definir associações.

### Parameters

Constituintes da CDS. São parâmetros de entrada pelo chamados ao realizar seleções de dados.

Permite equipar o usuário com opções de controlar a seleção de dados a partir desses parâmetros pré-definidos. Podem ser usados para restringir o resultado de uma seleção, agindo como um filtro.

São listados diretamente após o nome do modelo CDS.

```java
define view entity Z_ViewWithParameters
  with parameters
    P_KeyDate   : abap.dats,
    P_Language  : sylangu
as select from ...
```

### Campos de Referência (Reference Fields)

Campos de *amount* e *quantity* vão precisar de campos de referência, moeda e unidade nesse caso. No ABAP clássico, tecnicamente, é imposta a mesma regra para os tipos *curr* ou *quan*.

Nos modelos CDS, as referências a moeda e unidade são estabelicidas por meio de anotações.

```java
@Semantics.quantity.unitOfMeasure : 'Unity'
@Semantics.amount.currencyCode    : 'Currency'
```

Códigos de moeda: Tabela **TCURC**
Unidades de quantidade: Tabela **T006**

```java
{
@Semantics.quantity.unitOfMeasure : 'Unity'
quantity  as Quantity,
unity     as Unity,
@Semantics.amount.currencyCode : 'Currency'
value     as Value,
currency  as Currency,
}
```

#### Funções de conversão para campos de moeda e unidade 

```java
define view entity Z_ViewWithUnitConversions
  with parameters
    P_DisplayUnit : msehi
  as select from ZI_SalesOrderItem
{
  key SalesOrder,
  key SalesOrderItem,
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
  OrderQuantity,
  OrderQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityDisplayUnit'
  unit_conversion( quantity      => OrderQuantity,
                   source_unit   => OrderQuantityUnit,
                   target_unit   => $parameters.P_DisplayUnit,
                   error_handling => 'FAIL_ON_ERROR' )
    as OrderQuantityInDisplayUnit,
  $parameters.P_DisplayUnit as OrderQuantityDisplayUnit
}
```

```java
define view entity Z_ViewWithCurrencyConversions
  with parameters
    P_DisplayCurrency    : waers_curc,
    P_ExchangeRateDate   : sydatum
  as select from ZI_SalesOrderItem
{
  key SalesOrder,
  key SalesOrderItem,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  NetAmount,
  TransactionCurrency,
  @Semantics.amount.currencyCode: 'DisplayCurrency'
  currency_conversion(
    amount              => NetAmount,
    source_currency     => TransactionCurrency,
    target_currency     => $parameters.P_DisplayCurrency,
    exchange_rate_date  => $parameters.P_ExchangeRateDate,
    exchange_rate_type  => 'M',
    round               => 'X',
    decimal_shift       => 'X',
    decimal_shift_back  => 'X',
    error_handling      => 'SET_TO_NULL' )
  as NetAmountInDisplayCurrency,
  $parameters.P_DisplayCurrency as DisplayCurrency
}
```

### Provider Contracts

Os contatos de provedor de CDS definem formalmente regras que são a definição de um modelo de CDS. São o propósito da CDS.

Em termos de conteúdo, os contratos correspondem aos padrões de modelagem capturados pela anotação *@ObjectModel.modelingPattern*. Apenas o modelo raiz da CDS pode receber um contrato de provider e seus "filhos" composite herdam esse contrato.

**Tipos de Contrato**:

Interfaces Transacionais - Destinadas a servir como interface pública estável. Lançadas sobre um contrato de lançamento.

Query Transacional - Mais comum. Consultas transacionais CDS são destinadas a modelar a camada de projeção de um objeto de negócios RAP no contexto do ABAP RAP. Representam a camada mais alta de um modelo de dados CDS e têm o propósito de preparar os dados para um caso de uso específico. 

Query Analítica - Modelagem de consultas analíticas dentro do modelo de dados CDS. Entidade projetada deve ser uma visualização de cubo analítico. Recursos são restritos aos mecanimos analíticos.

### Entity Buffer Definitions

As definições de buffer de entidade permitem acelerar as seleções das visualizações de CDS no ABAP. Há dados que não podem ser armazenados em buffer.

Os responsáveis pela visualização da CDS precisam documentar por meio da anotação *AbapCatalog.entityBuffer.definitionAllowed: true* que eles estão cinetes dessas limitações técnicas e que eles vão considerar essas restrições durante o ciclo de vida posterias das visualizações CDS anotadas. Se quiser habilitar um buffer para uma CDS, que usa outras CDS como fonte dados, essas subjacentes precisam suportar também o buffer.

Administração de buffers pode implicar em uma sobrecarga significativa e impactar negativamente o consumo de recursos e o desempenho. Colocar dados que não mudam com frequência.

**Criar um buffer**: Selecionar a CDS; *New Entity Buffer* pelo menu de contexto; Insira as informações solicitadas na caixa de diálogo; e confirme a criação.

A definição e aplicação do buffer estará sempre alinhada com as seleções de dados reais. Por um lado, buffers podem restringir a evolução futura de uma visão CDS. Por outro, é preciso entender que nem todas as seleções podem ser executadas em servidor ABAP. 

## 4 - Associations

### Define Associations

As definições de associação descrevem as relações das respectivas fontes de definição com seus alvos associados no nível do registro. Funcionam como se fosse um JOIN.

**Associações buscam dados de outras CDSs ou tabelas**.

Em princípio, um único registro de dados de uma visualização CDS de origem pode estar relacionado a qualquer número de registros de dados de seu destino de associação, dependendo do especificado sob a condição da associação.

Vice-versa, pode haver números diferentes de registros de dados de origem para um determinado registro de destino.

O número possível de registros de dados correspondentes especifica a cardinalidade de uma associação.

Existem duas alternativas para especificar a cardinalidade de uma associação:

- Uma especificação de cardinalidade entre colchetes **[...]** descreve pelos limites inferiores e superiores capturados o número mínimo e máximo de registros de dados do alvo de associação que estão relacionados a um único registro de origem.

- Uma especificação de cardinalidade usando os elementos de sintaxe *[OF [EXACT] ONE/MANY] TO [EXACT] ONE/MANY* permite não apenas capturar a cardinalidade alvo, mas também a cardinalidade de origem.

| Cardinality         | Records of Association Source |                           | Records of Association Target |                           |
|---------------------|-------------------------------|---------------------------|-------------------------------|---------------------------|
|                     | **Minimum**                   | **Maximum**               | **Minimum**                   | **Maximum**               |
| [1]                 | 0                             | Unlimited                 | 1                             | 1                         |
| [0..1]              | 0                             | Unlimited                 | 0                             | 1                         |
| [1..1]              | 0                             | Unlimited                 | 1                             | 1                         |
| [0..*]              | 0                             | Unlimited                 | 0                             | Unlimited                 |
| [1..*]              | 0                             | Unlimited                 | 1                             | Unlimited                 |
| TO ONE              | 0                             | Unlimited                 | 0                             | 1                         |
| TO EXACT ONE        | 0                             | Unlimited                 | 1                             | 1                         |
| TO MANY             | 0                             | Unlimited                 | 0                             | Unlimited                 |
| OF ONE TO ONE       | 0                             | 1                         | 0                             | 1                         |
| OF EXACT ONE TO ONE | 1                             | 1                         | 0                             | 1                         |
| OF EXACT ONE TO EXACT ONE | 1                       | 1                         | 1                             | 1                         |
| OF MANY TO MANY     | 0                             | Unlimited                 | 0                             | Unlimited                 |
| OF MANY TO ONE      | 0                             | Unlimited                 | 0                             | 1                         |
| OF MANY TO EXACT ONE| 0                             | Unlimited                 | 1                             | 1                         |
| Not specified (default logic) | 0                         | Unlimited                 | 0                             | 1                     |
## Boas Práticas

### Evite lógica de negócios em visualizações CDS

Tente usar o CDS Views apenas para modelagem de dados. 

Se você adicionar algumas condições ou regras relacionadas a negócios, elas provavelmente precisarão de atualizações frequentes, que podem quebrar programas, que usam essas vistas do CDS, e testes de unidade. Mudanças nas Visualizações do CDS também podem influenciar as Visões de CDS superiores de forma implícita.

Use CDS Views apenas como modelos de dados e separar a lógica de negócios correspondente em programas ABAP ou objetos de negócio.

### Evite acesso direto a tabelas de banco de dados e funções de tabela na hierarquia de visualização CDS da camada superior

Para cada tabela de banco de dados, deve ser criada uma visualização de base de dados ou uma função de tabela correspondente à Visualização Básica do CDS. Essas vistas descrevem nomes significativos para campos de tabelas de banco de dados, adicionam associações e anotações específicas de dados.

Por exemplo, uma vista `I_Material` para a tabela `MARA`.

Use Basic Views em vez de acesso direto a tabelas de banco de dados em Visualização de CDS. Criar a Visualização Básica do CDS quando você criar uma nova tabela de banco de dados e quiser acessar seus dados no CDS.

## Atalhos Eclipse 

- SHIFT + F1 = Pretty Printer

- CTRL + CLICK = Transitar para tabelas, composites, views, etc

- CTRL + SPACE = Visualizar campos da tabela automaticamente, funções, possíveis implementações.