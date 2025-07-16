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

**Associações buscam dados de outras CDSs ou tabelas**. Podem ser alvos de associação: CDS views; CDS table functions; CDS abstract entities; Database Tables.

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



### Expose Associations

Ao definir uma associação, a associação se torna disponível para a implementação interna de uma visualização CDS.

Para tornar a associação acessível aos consumidores da visualização CDS, ela deve ser incluída na lista de projeção da visualização CDS da mesma forma que os campos. Sem essa exposição, a definição de associação é apenas um detalhe de implementação interna.

É possível também realizar sua funcionalidade usando junções correspondentes.

```java
define view entity ZI_SalesOrder
  as select from ...
{
  association [0..*] to ZI_SalesOrderItem as _Item
    on $projection.SalesOrder = _Item.SalesOrder

  key SalesOrder,
  _Item,
  ...
}
```

### Model Compositional Relations

Modelos de composição, ou **associações de composição**, representam uma especialização de associações

Eles modelam uma relação baseada na existência entre um filho composicional e seu pai.

Por exemplo, eles podem ser usados para definir que um item de pedido de venda (filho de composição) sempre pertence a um cabeçalho de ordem de vendas (pai de composição).

Existem elementos específicos de sintaxe CDS que você pode usar para definir relações composicionais.

```java
define root view entity Z_CompositionRootView
  as select distinct from t000
{
  composition [0..*] of Z_CompositionChildView as _ChildView

  key abap.char(1) as RootKeyField,
  _ChildView
}
```

Um filho de composição deve especificar uma associação principal para seu pai de composição e expor essa associação em sua lista de projeção.

Como há uma dependência estrita da existência de um único registro pai, a cardinalidade alvo mínima e máxima dessa associação é sempre 1.

A cardinalidade é determinada pela associação de composição correspondente.

Portanto, a especificação de cardinalidade é omitida na definição de tais associações.

```java
define view entity Z_CompositionChildView
  as select distinct from t000
{
  association to parent Z_CompositionRootView as _RootView
    on $projection.RootKeyField = _RootView.RootKeyField

  composition [0..*] of Z_CompositionGrandchildView
    as _GrandchildView

  key abap.char(1) as RootKeyField,
  key abap.char(1) as ChildKeyField,
  _RootView,
  _GrandchildView
}
```

### Project Associations

Você pode incluir as associações expostas de uma entidade CDS subjacente na lista de projeção de sua própria visualização CDS e, assim, expô-las lá também.

Se necessário, você pode atribuir nomes de alias às associações projetadas.

Em outras palavras, as associações expostas de uma entidade CDS podem, em princípio, ser usadas da mesma forma que os campos desta visualização CDS dentro da implementação de outra visualização CDS.

```java
define view entity ZI_SalesOrder
  as select from ...
{
  association [0..*] to ZI_SalesOrderItem as _Item
    on $projection.SalesOrder = _Item.SalesOrder

  key SalesOrder,
      _Item,
  ...
}

define view entity ZC_SalesOrder
  as select from ZI_SalesOrder
{
  key ZI_SalesOrder.SalesOrder,
      ZI_SalesOrder._Item as _SalesOrderItem
}
```

#### Define Path Expressions

Monta uma hieraquia de CDSs. O Path Expressions faz utilização dos *exposes* de cada CDS em um nível superior. Permite que a arquitetura da CDS fique muito mais performática.

Hieraquia:
Schedule -> Order Item -> Product -> Product Text

```java
define view entity Z_ViewWithPathExpressions
  as select from ZI_SalesOrderScheduleLine
{
  key SalesOrder,
  key SalesOrderItem,
  key SalesOrderScheduleLine,
      _SalesOrderItem,
      _SalesOrderItem.Product as SalesOrderItemProduct,
      _SalesOrderItem._Product,
      _SalesOrderItem._Product.Product,
      _SalesOrderItem._Product._Text
}
```

#### Implicit Joins (Joins Implícitos)

Se os campos forem adicionados usando expressões de path, as condições definidas nas definições de associação serão implicitamente convertidas em JOINs.

Consequentemente, as duas expressões de caminho, _SalesOrderItem.Product e _SalesOrderItem._Product.Product, resultam em dois JOINs efetivos. Mesmo sem associações, na *query* são feitos Joins de forma implícita.  

```java
define view entity Z_ViewWithPathExpressions
  as select from ZI_SalesOrderScheduleLine
{
  key SalesOrder,
  key SalesOrderItem,
  key SalesOrderScheduleLine,
      _SalesOrderItem,
      _SalesOrderItem.Product as SalesOrderItemProduct,
      _SalesOrderItem._Product,
      _SalesOrderItem._Product.Product,
      _SalesOrderItem._Product._Text
}
```
```SQL
CREATE OR REPLACE VIEW "Z_VIEWWITHPATHEXPRESSIONS" AS SELECT
  "ZI_SALESORDERSCHEDULELINE"."MANDT" AS "MANDT",
  "ZI_SALESORDERSCHEDULELINE"."SALESORDER",
  "ZI_SALESORDERSCHEDULELINE"."SALESORDERITEM",
  "ZI_SALESORDERSCHEDULELINE"."SALESORDERSCHEDULELINE",
  "A0"."PRODUCT" AS "SALESORDERITEMPRODUCT"
FROM
  "ZI_SALESORDERSCHEDULELINE"
  LEFT OUTER MANY TO ONE JOIN "ZI_SALESORDERITEM" AS "A0" ON
    "ZI_SALESORDERSCHEDULELINE"."SALESORDER" = "A0"."SALESORDER" AND
    "ZI_SALESORDERSCHEDULELINE"."SALESORDERITEM" = "A0"."SALESORDERITEM" AND
    "ZI_SALESORDERSCHEDULELINE"."MANDT" = "A0"."MANDT"
  LEFT OUTER MANY TO ONE JOIN "ZI_PRODUCT" AS "A1" ON
    "ZI_SALESORDERITEM"."PRODUCT" = "A1"."PRODUCT" AND
    "ZI_SALESORDERITEM"."MANDT" = "A1"."MANDT"
```

Em nível de banco de dados, os Joins substituem as associações. Também é possível declarar os Joins manualmente sem se preocupar em fazer exposição de outras associações.

**Você deve evitar usar junções (potencialmente implícitas) de fontes de dados para manter a complexidade estática das suas CDS mais baixa.**

Essa consideração é especialmente importante para suas CDS centrais e reutilizadas. Em vez de desnormalizar explicitamente ou implicitamente modelos CDS, deve-se tentar modelar as relações correspondentes das fontes de dados usando associações e disponibilizando essas associações para os consumidores de suas visualizações CDS (possivelmente distribuídas por várias visualizações CDS associadas).

Os consumidores podem então navegar seguindo as associações expostas, descobrir toda a rede de modelos conectados e realizar apenas as junções que são realmente necessárias.


#### Mudanças na Cardinalidade 

As expressões de path podem influenciar o número de registros de dados selecionados e, assim, influenciar a cadinalidade do resultado da seleção, introduzindo junções e filtros.

```java
define view entity Z_ViewWithPathExprsChngngCards
  as select from ZI_Product
{
  key Product,
  key _Text[*:inner].Language
}
```

É possível também filtrar pelo campo, restrigindo por uma constante.

```java
define view entity Z_ViewWithPathExprsChngngCards
  as select from ZI_Product
{
  key Product,
      _Text[1:Language='E'].ProductName As ProductNameInEnglish,
      _Text[1:Language='E'].Product As ProductTextInEnglish,
}
```

Na hora do *association* é possível usar do comando **with default filter** para definir a constante "E" para o campo Language.


### Utilização de Associations dentro do Código ABAP

Dentro da sua aplicação ABAP, você pode aproveitar as associações expostas de uma visualização CDS ao selecionar dados desta visualização CDS.

Assim como na CDS, você pode especificar expressões de caminho com associações no código ABAP.

Essas expressões de caminho podem acessar os campos das respectivas visualizações CDS alvo.

No entanto, ao contrário das visualizações CDS, você não pode incluir nenhuma associação como um elemento na lista de resultados do seu comando select.

```sql
SELECT \_salesorder-salesordertype,
       \_salesorderitem\_product\_text[ (1) inner : 
         where language = 'E' ]-productname
  FROM zi_salesorderscheduleline
  WHERE \_salesorderitem\_product-producttype EQ 'FERT'
  INTO TABLE @DATA(lt_result).
```

## Annotations

### Sintaxe

Conceito básico de modelagem da CDS

As definições de anotação tem tipo de objeto técnico DDLA. São definidos pela própria SAP e enviados como os próprios modelos CDS.

CRTL + SHIFT + A no Eclipse para visualizar as Annotations

Ao aplicar anotações dentro das definições de CDS utiliza-se o **@**. Devem ser localizadas antes do nome da entidade anotada ou de seu componente. Exemplo de anotações: EndUserText; AbapCatalog; Semantics.

```java
@EndUserText.label : 'Tabela Order Item'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zzdlcdst_ord_it {

  key client           : abap.clnt not null;
  key sales_order      : int4 not null;
  key sales_order_item : int4 not null;
  product              : int4;
  @Semantics.quantity.unitOfMeasure : 'zzdlcdst_ord_it.product_unity'
  product_quantity     : abap.quan(10,2);
  product_unity        : meins;
  @Semantics.amount.currencyCode : 'zzdlcdst_ord_it.currency'
  total_value          : abap.curr(10,2);
  currency             : waers;
  @Semantics.systemDateTime.createdAt: true
  creation_date        : dats;
  creation_user        : uname;
  last_changed_by      : uname;
  last_changed_from    : timestamp;
}
```

#### Annotation Names

Nomes de anotações são estruturados hierarquicamente. O nome de anotação totalmente qualificado é composto sucessivamente de vários níveis potenciais de hieraquia de componentes intermidários, terminando com um elemento folha. Os compontentes individuais são separados por pontos.

Por exemplo: **@Semantics.quantity.unitOfMeasure**

- Semantics = domínio
- quantity = elemento intermediário
- unitOfMeasure = elemento folha

Elementos estruturais intermediários podem ramificar, formando uma árvore de nomes de anotação. A tabela a seguir mostra os domínios de maior importância. 

| Domain           | Description                                                                                      |
|------------------|--------------------------------------------------------------------------------------------------|
| ABAPCatalog      | Controls the ABAP runtime environment as well as the ABAP Data Dictionary and defines extensibility options |
| AccessControl    | Documents and controls the authorization checks for CDS models                                   |
| Aggregation      | Defines elements that can be used as aggregating key figures (successor of DefaultAggregation)   |
| Analytics        | Defines analytical data models and applications                                                  |
| AnalyticsDetails | Defines the details of an analytical query, such as its standard layout and the exception aggregations to be applied |
| Consumption      | Provides hints for CDS model consumers that are evaluated in particular by implementation frameworks |
| EndUserText      | Defines translatable label texts                                                                  |
| Environment      | Controls the defaulting logic of parameters with system variables as well as special SQL operations |
| Event            | Defines properties of event signatures                                                            |
| Hierarchy        | Defines hierarchical relationships                                                                |
| Metadata         | Controls the annotation enrichments of a CDS view by enabling CDS metadata extensions and the propagation of element annotations |
| ObjectModel      | Describes the basic structural properties of the data models                                      |
| OData            | Defines the exposure of CDS models in OData services                                              |
| Search           | Controls the search functionality                                                                 |
| Semantics        | Describes the basic semantics of types, elements, and parameters                                  |
| UI               | Defines a semantic user interface (UI) representation that is independent of the specific UI implementation technology |
| VDM              | Classifies CDS models in the virtual data model (VDM)                                             |

#### Annotation Types and Values

Os tipos de anotações CDS podem representar um valor escalar, uma estrutura ou um array. 

Ao anotar um modelo CDS, a tipagem consistente é reforçada pelas verificações de sintaxe CDS. Valores de anotação só são permitidos se eles correspoderem aos tipos especificados da anotação CDS.

Dependendo da atribuição de tipo real, os valores admissíveis podem ser: Valores Booleanos, Valores de String, Referências a elementos CDS.

#### Valores de enumeração (Enumeration Values)

Os valores de enumeração são usados para restringir a faixa de valores escalares admissíveis que são tecnicamente definidos pelo tipo de uma anotação CDS.

As constantes capturadas nas listas de enumeração têm um significado semântico, que pode ser interpretado pelo ambiente de runtime do ABAP ou por frameworks que executam ou usam os modelos CDS.

Dentro das definições de anotação, essas listas de valores admissíveis são especificadas pela palavra-chave enum.

A enumeração ilustrada define que a anotação ObjectModel.dataCategory só pode ter um desses valores: TEXT, HIERARCHY, ou VALUE_HELP.

```java
annotation ObjectModel {
  ...
  dataCategory : String(30) enum { TEXT;
                                   HIERARCHY;
                                   VALUE_HELP; };
  ...
};
```

Se um valor de enumeração deve ser usado para especificar uma anotação em um modelo CDS, esse valor pode ser endereçado diretamente pelo caractere especial **#**.

Neste exemplo, a categoria de dados da visão CDS **ZI_ProductText** é definida como TEXT referenciando (**#**) o valor de enumeração correspondente da anotação **ObjectModel.dataCategory**.

```java
@ObjectModel.dataCategory: #TEXT
define view entity ZI_ProductText as select ...
```


#### Valores iniciais de Anotações (Annotation Default Values)

Valores padrão especificados na definição de anotação CDS. Tal valor padrão se aplica se a anotação for usada sem uma avaliação esplícita. 

#### Escopo de Anotação (Annotation Scopes)

Dentro do modelo CDS, as anotações podem aparecer no nível do cabeçalho para fornecer informações para as entidades CDS anotadas como um todo ou no nível de componente individual (parâmetros ou elementos projetados).

A especificação de escopo define onde uma determinada anotação é admissível para ser usada dentro de um modelo CDS. Por exemplo, o escopo da anotação Semantics.quantity é definido como ELEMENT.

Como resultado, essa anotação pode ser usada para anotar elementos CDS, ou seja, campos e associações.

Ela não pode ser usada para anotar parâmetros ou modelos CDS inteiros.

Anotações como Semantics.systemDate.createdAt e Semantics.quantity.unitOfMeasure, que não são especificamente definidas com seus próprios escopos, herdam suas configurações de escopo de suas anotações pai, Semantics.systemDate e Semantics.quantity, respectivamente.

Definir escopos de anotação requer obter respostas para as seguintes perguntas:
  - A anotação pode ser usada mais de uma vez ou no máximo uma vez em um modelo CDS?
  - Será possível usar a anotação em visualizações estendidas do CDS?
  - A anotação será ou poderá ser propagada por todo o stack de visualização do CDS?

### Efeitos das Annotations

Os metadados capturados nas anotações do CDS podem controlar tanto a geração de artefatos no momento do projeto quanto a aplicação da lógica CDS modelada em tempo de execução.

Além disso, as anotações da CDS também podem ter como objetivo documentar certas propriedades dos modelos do CDS.

Essas propriedades documentadas podem ser usadas, por exemplo, para identificar modelos CDS relevantes, bem como para verificações de consistência dos mesmos.

Vejamos a visualização de CDS de amostra Z_ViewWithODataExposure, que está equipada com várias anotações, que discutiremos nesta aula.

```java
@ObjectModel.usageType: { serviceQuality : #B,
                          sizeCategory  : #XL,
                          dataClass     : #TRANSACTIONAL }

@OData.entityType.name: 'ViewWithODataExposure_Type'

define view entity Z_ViewWithODataExposure
  with parameters
    P_CreationDate : sy-datum
  as select from ZI_SalesOrderItem

  @Consumption.hidden: true
  @Environment.systemField: #SYSTEM_DATE

{
  key SalesOrder,
  key SalesOrderItem,
      CreationDate
}
where CreationDate = $parameters.P_CreationDate
```

Como mencionado, as estruturas podem aproveitar as informações capturadas em anotações para gerar seus artefatos de tempo de design.

Exemplos de tais artefatos são os serviços OData, que são criados pela infraestrutura da Linguagem de Definição de Adaptação de Serviço (SADL) a partir de modelos CDS.

Se a visualização CDS Z_ViewWithODataExposure for exposta como uma entidade em um serviço OData, o nome do tipo de entidade OData é derivado da anotação @OData.entityType.name, conforme mostrado:

```java
@OData.entityType.name: 'ViewWithODataExposure_Type'
```

```java
<EntityType ... Name="ViewWithODataExposure_Type">
  <Key>
```

As anotações de CDS também são interpretadas pelo ambiente de tempo de execução ABAP e podem influenciar a execução de uma seleção de dados.

Por exemplo, parâmetros de modelos CDS podem ser mapeados por anotações CDS em variáveis de tempo de execução.

O ambiente de tempo de execução ABAP atribui automaticamente os respectivos campos do sistema aos parâmetros que são anotados dessa maneira se eles não forem fornecidos explicitamente no contexto de uma seleção de dados através da interface ABAP SQL.

Em nosso exemplo, aproveitamos esse mecanismo para fornecer o parâmetro P_CreationDate com a data atual do sistema
@Environment.systemField: #SYSTEM_DATE

O parâmetro em si não será exposto aos consumidores de serviços, por isso é anotado com @Consumption.hidden: true.

```java
with parameters  
  @Consumption.hidden: true  
  @Environment.systemField: #SYSTEM_DATE  
  P_CreationDate : sy-datum
```

Além das anotações CDS que afetam direta ou indiretamente a execução em tempo de execução de uma seleção de dados, também há anotações CDS que servem apenas para fins de documentação.

Essas anotações suportam a seleção de modelos CDS adequados, bem como análises e verificações dos mesmos.

Por exemplo, você pode usar classificações de desempenho @ObjectModel.usageType... para selecionar um modelo CDS que atenda aos requisitos de seu aplicativo em relação à taxa de transferência de dados e eficiência de processamento.

Vamos dar uma olhada nas anotações de visualização CDS correspondentes.

Qualidade de serviço @ObjectModel.usageType.serviceQuality descreve quais características de desempenho um modelo CDS possui.

O valor de qualidade B significa que o modelo CDS pode, em princípio, ser usado dentro da lógica de aplicativos transacionais.

A categoria de tamanho especificada @ObjectModel.usageType.sizeCategory responde à questão de quantos registros de dados são normalmente processados dentro de uma solicitação de seleção.

Nesse contexto, não é importante quantos registros de dados o resultado da seleção contém, mas sim quantos registros de dados são efetivamente usados para seu cálculo.

A categoria de tamanho mantida fornece uma dica para estimar os requisitos de recursos de uma solicitação de seleção no banco de dados SAP HANA.

No exemplo dado, o valor XL significa que o processamento de menos de 100 milhões de registros de dados é esperado.

```java
@ObjectModel.usageType: {
    serviceQuality : #B,
    sizeCategory   : #XL,
    dataClass      : #TRANSACTIONAL
}
```

Por fim, a categoria de dados  @ObjectModel.usageType.dataClass pode ser usada como um indicador para os consumidores definirem estratégias de cache adequadas para os dados selecionados.

Considerando que os metadados geralmente só mudam devido a correções ou atualização de um sistema e , portanto, podem ser apropriados para buffer, os dados transacionais (TRANSACTIONAL) devem ser considerados voláteis.

Em outras palavras, esses dados podem estar sujeitos a mudanças frequentes e signigicativas ao longo do tempo.

Consequentemente, deve-se esperar que os dados correspondentes, se armazenados em buffer, se tornem desatualizados após um período de tempo.

### Propagação

Modelos de CDS podem ser definidos um em cima do outro. Isso se aplica aos tipos simples de CDS, bem como aos outros modelos de visualização.

Por padrão, as anotações dos modelos CDS Filhos são tranferidos para os modelos Pai. A consistência é garantida ao aplicar uma lógica de propagação.

### Extensões de Metadados (Metadata Extensions)

Extensões de metadados CDS são objetos de desenvolvimento transportáveis do tipo técnico **DDLX**.

Em princípio, extensões de metadados CDS permitem que você enriqueça e substitua as anotações ativas existentes de um modelo CDS, que suporta extensões de metadados. Pode haver potencialmente uma pluralidade de extensões de metadados CDS para uma única entidade CDS.

As extensões de metadados do CDS são organizadas em camadas.

Elas se sobrepõem umas às outras de acordo com a camada à qual são atribuídas. A imagem fornece uma visão geral dos relacionamentos de sobreposição entre as camadas.


| Layer        | Overlays Layer (Including All Subordinate Layers) |
|--------------|----------------------------------------------------|
| CUSTOMER     | PARTNER                                            |
| PARTNER      | INDUSTRY                                           |
| INDUSTRY     | LOCALIZATION                                       |
| LOCALIZATION | CORE                                               |
| CORE         | –                                                  |

Por exemplo, extensões de metadados CDS da camada PARTNER sobrepõem todas as extensões de metadados CDS da camada INDUSTRY.

Isso se aplica a todas as extensões de metadados CDS das camadas subordinadas LOCALIZATION e CORE da camada INDUSTRY também.

Dentro da mesma camada, a ordem de sobreposição das extensões de metadados CDS não é definida e, portanto, não é garantida.

```java
@Metadata.allowExtensions: true
define view entity ZC_SalesOrderItem
  as select from ZI_SalesOrderItem
{
  @EndUserText.label: 'Sales Order'
  key SalesOrder,
  key SalesOrderItem,
      Product
}
```

```java
@Metadata.layer: #CUSTOMER
annotate view ZC_SalesOrderItem with
{
  @UI.lineItem: [{importance: #HIGH}]
  SalesOrder;

  @UI.lineItem: [{importance: #HIGH}]
  SalesOrderItem;
}
```

## Controle de Acesso (Access Controls)

### Fundamentos of Access Controls

Do ponto de vista da autorização, um usuário final deve ter acesso somente às funções e dados necessários para cumprir tarefas comerciais específicas (seguindo o princípio do menor privilégio).

Isso significa que um usuário deve ter somente um conjunto mínimo de autorizações (LGPD).

Um controle de autorização suportado pelo sistema pode ser configurado no nível funcional, bem como no nível de registros de dados individuais (ou para informações parciais deles).

Em particular, o acesso a dados pessoais sensíveis não requer apenas uma proteção funcional do aplicativo, que é chamada de autorização inicial, mas também um controle granular fino, que permite diferenciar o acesso aos registros de dados protegidos individuais (autorização de instância) avaliando os valores que eles contêm.

O exemplo a seguir ilustra as diferenças entre os dois níveis mencionados de controle de autorização:
- Em princípio, os funcionários do departamento de vendas e distribuição devem ser capazes de criar e visualizar pedidos de vendas.
- Em contraste, os funcionários do departamento de recursos humanos não devem ser capazes de usar as funções correspondentes.

Isso pode ser alcançado não concedendo aos últimos funcionários acesso aos aplicativos do departamento de vendas e distribuição; ou seja, eles não recebem nenhuma autorização de início para eles (chamada da transação, do app, etc).


Os controles de acesso CDS são definidos como funções CDS que alavancam a linguagem de controle de dados (DCL).

No ambiente ABAP Development Tools (ADT), eles são criados em um diálogo guiado semelhante aos modelos de dados CDS.

Este diálogo de criação pode ser aberto, por exemplo, indo para a barra de menu e escolhendo
-> Arquivo - Novo - Outro - ABAP Core Data Services - Access Control.

Na primeira etapa do assistente de criação, você pode inserir o nome (Name) do objeto DCLS, sua descrição (Description) e a entidade CDS (Protected Entity), que se refere aos dados que serão protegidos pelo controle de acesso CDS.


No exemplo, o nome do DCLS corresponde ao nome da entidade CDS protegida ZI_SalesOrder em letras maiúsculas.

A implementação do controle de acesso imediatamente após sair do assistente de criação clicando em Concluir.

```java
@EndUserText.label: 'Auto assigned mapping role for ZI_SalesOrder'
@MappingRole: true
define role ZI_SALESORDER {
    grant select on ZI_SalesOrder
    where (entity_element_1,
           entity_element_2)
        = aspect pfcg_auth(authorization_object,
                           authorization_field_1,
                           authorization_field_2,
                           filter_field_1 = 'filter_value_1');
}
```

Em princípio, as funções CDS podem conceder aos usuários acesso irrestrito aos resultados da seleção.

No entanto, as funções CDS geralmente contêm condições sob as quais o acesso aos dados dos modelos CDS protegidos é concedido aos usuários.

Essas regras de acesso podem ser compostas de várias condições de acesso.

As últimas podem ser formuladas correlacionando campos dos modelos CDS com o usuário conectado, com configurações específicas do usuário, com valores literais constantes ou com campos de autorização de objetos de autorização.

Esses objetos de autorização são os mesmos em que se baseia o conceito de autorização baseado em PFCG de transação.


### Mode of Action of Access Controls

Ao selecionar dados de um modelo CDS usando a interface ABAP SQL, as funções CDS, que são atribuídas aos modelos CDS, são avaliadas automaticamente.

Dependendo do resultado da avaliação, a instrução select é automaticamente enriquecida com critérios de filtro adicionais pelo ambiente de tempo de execução ABAP.

Os critérios de filtro injetados são derivados das regras de acesso, que são definidas nos controles de acesso do CDS, levando em consideração as autorizações do usuário conectado.

Você pode anotar seus modelos CDS com **@AccessControl.authorizationCheck**... para especificar se uma verificação de autorização é necessária para uma seleção de dados.

Se essa anotação estiver faltando, espera-se que nenhuma verificação de autorização seja necessária.

Isso corresponde a anotar implicitamente o modelo CDS correspondente com **@AccessControl.authorizationCheck:#NOT_REQUIRED**.

| Annotation Value | Description |
|------------------|-------------|
| **MANDATORY**     | The annotated CDS model will have a CDS access control. If no CDS access control is defined, data selections result in runtime errors. |
| **CHECK**         | The annotated CDS model will have a CDS access control. In contrast to value MANDATORY, no existence check for the CDS access control is performed at runtime. |
| **NOT_REQUIRED**  | In general, a CDS access control isn’t required. This value corresponds to the default value, which is specified in the annotation definition. |
| **NOT_ALLOWED**   | Defining a CDS access control isn’t allowed. Note that this value has no effect on the runtime. It prevents defined CDS access controls from becoming effective. |
| **PRIVILEGED_ONLY** | A direct data selection from the annotated CDS model is only possible through privileged access, which requires a special addition to the standard ABAP SQL statement. |


#### Implementar Access Controls

Defina acessos de controle de forma uniforme. Em muitos casos, todos os modelos CDS intimamente relacionados a um único objeto de aplicativo devem ser protegidos da mesma maneira.

Um exemplo típico é o documento de pedido de vendas, que é estruturado em dados de cabeçalho, item.

Por padrão, um funcionário de vendas deve ter permissão para visualizar a instância inteira do documento de pedido de vendas e não apenas suas partes.

Isso significa que um usuário deve ter permissão para visualizar os dados de cabeçalho de uma instância de pedido de vendas selecionada, bem como os dados correspondentes de seus itens.

Para realizar esse requisito, os controles de acesso do CDS para os modelos CDS correspondentes devem ser implementados de forma uniforme com base nas mesmas condições de acesso.

Nesse contexto, você pode aproveitar as expressões de path nas definições de função do CDS para introduzir campos que controlam o acesso e que ainda não fazem parte da lista de campos dos modelos CDS a serem protegidos.

Por exemplo, a proteção de acesso do cabeçalho do pedido de vendas CDS view ZI_SalesOrder, também pode ser implementada pela função CDS ZI_SalesOrderItem.

Isso é feito alavancando a associação _SalesOrder, que relaciona os registros dos itens aos registros dos cabeçalhos do pedido de vendas.

```java
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_SalesOrderItem
  as select from ...
  association [1..1] to ZI_SalesOrder as _SalesOrder
    on $projection.SalesOrder = _SalesOrder.SalesOrder
{
  key SalesOrder,
  key SalesOrderItem,
  _SalesOrder, ...
}
```

Aqui mostramos como está protegendo a função CDS ZI_SalesOrderItem.

Ele acessa o campo SalesOrderType da visualização CDS ZI_SalesOrder por meio da expressão de path _SalesOrder.SalesOrderType em uma condição de acesso.

Como resultado, os registros de dados do item do pedido de vendas são protegidos da mesma forma que o registro de dados correspondente do cabeçalho do pedido de vendas.

```java
@MappingRole: true
define role ZI_SalesOrderItem
  grant select on ZI_SalesOrderItem
    where ( _SalesOrder.SalesOrderType ) =
      aspect pfcg_auth ( V_VBAK_AAT,
                         AUART,
                         ACTVT = '03' );
```

#### Implementação de Herança do Acess Control

As opções de herança aplicáveis são explicadas no exemplo a seguir.

Mostramos uma visualização CDS ZC_SalesOrder, que projeta campos da visualização CDS ZI_SalesOrder, mostrada anteriormente.

```java
@AccessControl.authorizationCheck: #CHECK
define view entity ZC_SalesOrder
  as select from ZI_SalesOrder
{
  key SalesOrder,
      SalesOrderType
}
```
```java
@MappingRole: true
define role ZC_SalesOrder
{
  grant select on ZC_SalesOrder
    where ( SalesOrderType =
            aspect pfcg_auth ( V_VBAK_AAT,
                               AUART ),
            ACTVT = '03' );
}
```

Em vez de implementar a função CDS ZC_SalesOrder do zero, como mostrado, você também pode reutilizar a lógica da função CDS ZI_SalesOrder aplicando o mecanismo de herança dos controles de acesso CDS.

De uma perspectiva técnica, há três maneiras de implementar essa lógica de herança.

Como primeira alternativa, você pode definir as condições de acesso da função DCL ZC_SalesOrder herdando todas as condições de acesso definidas para a visualização CDS ZI_SalesOrder.

```java
@MappingRole: true
define role ZC_SalesOrder {
  grant select on ZC_SalesOrder
    where inheriting conditions from entity ZI_SalesOrder;
}
```

Como uma segunda alternativa, você pode definir as condições de acesso da função DCL ZC_SalesOrder herdando todas as condições de acesso da função DCL ZI_SalesOrder para sua visualização CDS protegida ZI_SalesOrder.

A implementação resultante é:
```java
@MappingRole: true
define role ZC_SalesOrder {
  grant select on ZC_SalesOrder
    where inherit ZI_SalesOrder for grant select on ZI_SalesOrder;
}
```

Como terceira alternativa, você pode herdar as regras de acesso da função DCL ZI_SalesOrder, conforme ilustrado.

```java
@MappingRole: true
define role ZC_SalesOrder {
  grant select on ZC_SalesOrder
    inherit ZI_SalesOrder;
}
```
*Esta opção é considerada obsoleta e não deve mais ser usada.*

#### Implementar Acess Control sem Objetos Auth

Nas definições de função do CDS, você pode avaliar diretamente o usuário conectado.

O aspecto do elemento de sintaxe user permite que você faça referência ao usuário nas condições de acesso que você define.

Ilustramos um exemplo em que os usuários estão autorizados a ler os pedidos de vendas da visualização CDS ZC_SalesOrder, que eles criaram (documentado pelo campo CreatedByUser).

```java
@MappingRole: true
define role ZC_SalesOrderCreatedByMe {
  grant select on ZC_SalesOrder
    where CreatedByUser = aspect user;
}
```

Em alguns casos, você pode querer aplicar um controle de acesso baseado em sua própria entidade que contém informações específicas do usuário.

Nesses casos, você pode avaliar o uso de aspectos autodefinidos.

Além da entidade CDS protegida e sua função CDS, você tem que definir a entidade CDS fornecendo as configurações específicas do usuário e o próprio aspecto autodefinido, o que é ilustrado no exemplo a seguir.

Vamos supor que você tenha uma lista de usuários que são responsáveis por tipos de pedidos de vendas dedicados.

Essa lista se tornará a base para controlar o acesso aos pedidos de vendas.
```java
@AccessControl.auditing.specification: '...'
@AccessControl.auditing.type: #CUSTOM
define view entity Z_ViewAsDataSourceForDclAspect
  as select distinct from t000
{
  key cast( abap.char('USER_A') as vdm_userid ) as UserID,
      abap.char('TAF') as SalesOrderType
}
union select distinct from t000
{
  key abap.char('USER_B') as UserID,
      abap.char('OAF') as SalesOrderType
}
```
```java
define accesspolicy Z_DCLASPECT {
  define aspect Z_DCLASPECT as
    select from Z_ViewAsDataSourceForDclAspect
    with user element UserID
    {
      SalesOrderType
    }
}
```
```java
@MappingRole: true
define role Z_ViewWithDclAspect {
  grant select on Z_ViewWithDclAspect
    where
      SalesOrderType = aspect Z_DclAspect;
}
```

Você também pode usar **valores literais** constantes para definir condições de acesso que não dependerão do usuário conectado.

Essas condições independentes do usuário são principalmente adequadas para conceder a todos os usuários acesso a certos registros de dados ou para bloquear o acesso para todos os usuários por padrão.

No último caso, uma adição especial à instrução select em ABAP é necessária para ainda ler os registros de dados afetados.

#### Implementar Access Controls para Queries Analíticas

#### Implementar Access Controls para Transactional App

#### Implementar Access Control a Nível de Campo

#### Modificações em Access Controls Liberadas pela SAP

Você não pode alterar as definições de função CDS fornecidas pela SAP para atender aos seus requisitos sem aplicar modificações técnicas.

No entanto, ao definir uma função CDS adicional, você pode modificar efetivamente o controle de acesso existente de um modelo CDS da SAP.

De uma perspectiva funcional, dois mecanismos são suportados para adaptar uma função CDS por meio de outra função CDS:
 - Substituir os controles de acesso CDS existentes.
 - Combinar a lógica de suas funções CDS com as funções CDS existentes.

Apenas os modelo CDS com anotação **@AcessControl.authorizationCheck:#NOT_ALLOWED** representam uma exceção. Essa anotaão impede a aplicação de controles de acesso.

Ao redefinir um controle de acesso CDS usando o elemento de sintaxe de redefinição, você substitui completamente a sua lógica, conforme demonstrado em:

```java
@MappingRole: true
define role ZC_SalesOrderRedefined {
  grant select on ZC_SalesOrder
    redefinition
    where SalesOrderType = 'TAF';
}
```

Aqui, a proteção de acesso da visualização CDS ZC_SalesOrder é alterada de modo que os usuários possam acessar todos os registros de dados com o tipo de pedido de venda TAF.

Todas as outras restrições de acesso da visualização CDS ZC_SalesOrder são desativadas.

Em vez de substituir a proteção de acesso existente de um modelo CDS, você também pode incorporá-la completamente na sua função CDS redefinida.

Você pode alcançar isso usando a instrução que herda as condições da super.
```java
@MappingRole: true
define role ZC_SalesOrderRedefined {
  grant select on ZC_SalesOrder
    redefinition
    where inheriting conditions from super
      and SalesOrderType = 'TAF';
}
```

**combination mode or** e **combination mode and**


#### Block Standard Data Selecions from CDS

#### Desacoplando Access Controls do Input do Usuário

#### Map CDS Fields onto Fields of Auth Obj

### Testar Acess Control.

Deve-se testar a funcionalidade dos seus controles de acesso CDS no contexto dos serviços qie expõe os modelos CDS protegidos.

Esses testes de integração devem incluir seus aplicativos analíticos e serviços ODATA. Idealmente todas as funções e opções de seleção devem ser cobertas pelos testes.

Transação para testar controle de acesso manual: **SACMSEL**
  - Permite que você selecione os dados e analise os efeitos.

## Serviços de Negócio ( Business Services )

### Projection Views

Para adaptar seus modelos CDS ao cenário de uso desejado, você precisa criar visualizações específicas para o serviço. Essas visualizações podem ser feitas como entidades CDS padrão.

No contexto da programação ABAP RESTful, também existem visualizações CDS chamadas de **projeções**, que ajudam a automatizar o processamento transacional.

As visualizações de **projeção** são um tipo especial de visualizações CDS. O objetivo delas é *criar interfaces de serviço com base em modelos CDS* mais gerais.

Em geral, elas **não adionam novas funcionalidades**, mas organizam as funções existentes de maneira que possam ser facilmente usadas pelas interfaces de serviço.

As visualizações CDS de projeção têm algumas diferenças em relação às visualizações CDS normais.

Primeiro, as visualizações de projeção **só permitem definir projeções simples das fontes de dados subjacentes**, ou seja, não suportam consultas SQL complexas.

Além disso, elas **não podem ser usadas como fontes de dados para outras visualizações**, ou seja, servem apenas como a camada superior em uma hierarquia de visualizações.

A única exceção são as visualizações de projeção com o contrato CDS *transactional_interface*, que permitem criar outra camada de visualizações de projeção com o contrato *transactional_query* sobre elas.

Por fim, as visualizações de projeção podem especificar estruturas compostas apenas se forem baseadas em fontes de dados que também definem essas estruturas.

Esse aspecto é ilustrado no exemplo a seguir.

A CDS abaixo fornece um exemplo de uma composição de duas visualizações CDS base.

A visualização CDS ZI_Product define a visualização CDS raiz dessa composição.

```java
define root view entity ZI_Product
  as select from zproduct
  composition [0..*] of ZI_ProductText as _Text
{
  key product             as Product,
      product_type        as ProductType,
      creation_date_time  as CreationDateTime,
      _Text
}
```

```java
@ObjectModel.dataCategory: #TEXT
define view entity ZI_ProductText
  as select from zproducttext
  association to parent ZI_Product as _Product
    on $projection.Product = _Product.Product
{
  key language      as Language,
      product       as Product,
      product_name  as ProductName,
      _Product
}
```

No topo desta composição base, umas composição implementada por projection views é definida. A root projection view ZC_Porduct desta composição é mostrada em:

```java
define root view entity ZI_Product 
  as select from zproduct
  composition [0..*] of ZI_ProductText as _Text{

      key product             as Product,
      product_type        as ProductType,
      creation_date_time  as CreationDateTime,
      _Text

}
```

```java
define root view entity ZC_Product
  as projection on ZI_Product {
    @Consumption.valueHelpDefinition: [
      { entity: {name: 'ZI_ProductStdVH',
                 element: 'Product'}}]
    @ObjectModel.text.element: [ 'ProductName']

    key Product,
        ProductType,
        @Semantics.text: true
        _Text.ProductName : localized,
        _Text : redirect to composition child ZC_ProductText
  }
```

### Service Definition

As definições de serviço determinam o conjunto de entidades expostas em serviços de negócio.

Em teoria, essas definições são independentes dos *service bindings* usados e, portanto, dos protocolos (como **OData**) e cenários de uso (como UI).

Tecnicamente, é possível reutilizar uma única definição de serviço em vários service bindings e serviços de negócios.

Na prática, no entanto, a definição de serviço está geralmente ligada ao service binding planejado para atender aos requisitos funcionais do serviço de negócios.

Por isso, recomenda-se expor *uma definição de serviço em apenas um serviço*. Porém, é possível extender o Service Definition utilizando a annotation "**@AbapCatalog.extensibility.extensible: true**".

O *service binding* define o protocolo e o caso de uso que um serviço irá suportar.

As entidades e suas relações (incluindo sua funcionalidade) expostas por um serviço são derivadas das definições de serviço, que são atribuídas ao *service binding*.

#### Service Binding

Os *service bindings* para serviços:
- OData UI
- OData Web API
- InA
- SQL Web API

| **Binding Type**         | **Protocol**                          | **Description**                             |
|--------------------------|----------------------------------------|---------------------------------------------|
| OData V2 - UI            | OData V2                               | UI service                                  |
| OData V4 - UI            | OData V4                               | UI service                                  |
| OData V2 - Web API       | OData V2                               | Remote OData API service                    |
| OData V4 - Web API       | OData V4                               | Remote OData API service                    |
| InA - UI                 | InA                                    | Analytical query service for UI consumption |
| SQL - Web API            | Open Database Connectivity (ODBC)      | Remote SQL API service                      |

#### Use ODATA Service URLs

Os Serviços de Negócio podem ser testados de várias maneiras. 

As vinculações de serviço publicadas podem ser invocadas clicando no link exibido no campo URL do serviço.

Você pode ajustar essas URLs de serviço adicionando parâmetros que permitem que você solicite informações específicas sobre o serviço.

Por exemplo, você pode solicitar a exibição dos metadados do serviço de IU usando a seguinte solicitação:
.../sap/opu/odata4/sap/zui_product_display/srvd/sap/product/0001/$metadata

Além dos metadados, você também pode solicitar dados para os conjuntos de entidades individuais dos serviços.

Por exemplo, você pode solicitar os dados do produto do serviço de IU usando a seguinte solicitação:
.../sap/opu/odata4/sap/zui_product_display/srvd/sap/product/0001/Product

Ao variar as URLs dos serviços, você pode simular diferentes acessos à funcionalidade dos serviços e comparar suas respostas com suas expectativas.

#### Use UI Previews

Para serviços de UI OData, você também pode ter uma primeira impressão de uma UI do SAP Fiori Elements usando a função Preview mostrada anteriormente.

Este aplicativo UI pode ser usado para testar manualmente o serviço ODATA.

## Native SAP Hana

### Implementação CDS Table Function

Forma de colocar funções do banco de dados Hana dentro de uma CDS. Deve ser criada quando é preciso uma ação de banco para a CDS.

O sistema de banco de dados relacional SAP HANA não só pode ser usado por meio da linguagem de consulta estruturada (SQL), mas também oferece ferramentas e bibliotecas de funções para muitas áreas, como análise e pesquisa de texto, processamento de dados geográficos e gráficos, matemática financeira, análise preditiva e aprendizado de máquina.  

Você pode usar esses recursos por meio da linguagem específica do SAP HANA SQLScript, que combina elementos de linguagem SQL e imperativa.

Usando **ABAP-Managed Database Procedures (AMDPs)**, é possível executar SAP HANA SQLScript do ABAP enquanto passa dados por parâmetros de entrada e recebe os resultados.

Este método é aproveitado para funções de tabela CDS Tecnicamente, uma função de tabela SAP HANA é criada e executada. Uma função de tabela CDS pode ser usada como fonte de dados para uma visualização CDS, possibilitando o uso de recursos nativos do SAP HANA no CDS.

### App Cenarios




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

- CRTL + SHIFT + A = visualizar as Annotations