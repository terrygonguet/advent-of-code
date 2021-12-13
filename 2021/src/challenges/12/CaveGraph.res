open Js
open! Belt

type rec node = {
  id: string,
  isBig: bool,
  connections: array<node>,
}

type path = Vector.t<string>

type connection = (string, string)

let rec find_: (node, string, Set.String.t) => option<node> = (node, id, visited) => {
  if node.id == id {
    Some(node)
  } else {
    let visitedAndThis = visited->Set.String.add(node.id)
    switch node.connections->Array2.filter(({id}) => !(visitedAndThis->Set.String.has(id))) {
    | [] => None
    | connections =>
      connections->Array2.reduce(
        (acc, node) => acc->Js.Option.firstSome(node->find_(id, visitedAndThis)),
        None,
      )
    }
  }
}

let find: (node, string) => option<node> = (node, id) => find_(node, id, Set.String.empty)

let findOrDefault: (node, string) => node = (node, id) =>
  switch node->find(id) {
  | Some(node) => node
  | None => {id: id, isBig: Utils.isAllUpperCase(id), connections: []}
  }

let linkNodes = (a: node, b: node) => {
  if a.connections->Array2.find(n => n === b)->Js.Option.isNone {
    a.connections->Array2.push(b)->ignore
  }
  if b.connections->Array2.find(n => n === a)->Js.Option.isNone {
    b.connections->Array2.push(a)->ignore
  }
}

let addConnection: (node, connection) => node = (graph, connection) => {
  let (idFrom, idTo) = connection
  let nodeTo = graph->findOrDefault(idTo)

  ignore(
    switch graph->find(idFrom) {
    | Some(nodeFrom) => linkNodes(nodeFrom, nodeTo)
    | None => Exn.raiseError("Cannot find a node with id \"" ++ idFrom ++ "\"")
    },
  )

  graph
}

let make: array<connection> => node = connections => {
  let start = {id: "start", isBig: false, connections: []}

  while connections->Array2.length > 0 {
    let i =
      connections->Array2.findIndex(((idFrom, idTo)) =>
        start->find(idFrom)->Option.isSome || start->find(idTo)->Option.isSome
      )
    let connection = connections->Array2.spliceInPlace(~pos=i, ~remove=1, ~add=[])
    ignore(
      try {
        start->addConnection(connection->Array2.unsafe_get(0))
      } catch {
      | _ => {
          let (a, b) = connection->Array2.unsafe_get(0)
          start->addConnection((b, a))
        }
      },
    )
  }

  start
}

let rec findAllPathsBetween_: (node, node, path) => array<path> = (nodeFrom, nodeTo, path) =>
  if nodeFrom == nodeTo {
    [path |> Vector.append(nodeFrom.id)]
  } else {
    // %debugger
    let pathAndThis = path |> Vector.append(nodeFrom.id)
    nodeFrom.connections
    ->Array2.filter(({id, isBig}) => isBig || !(path->Utils.vectorHas(id)))
    ->Utils.flatMap(node => findAllPathsBetween_(node, nodeTo, pathAndThis))
  }

let findAllPathsBetween: (node, string, string) => array<path> = (graph, idFrom, idTo) =>
  switch graph->find(idFrom) {
  | Some(nodeFrom) =>
    switch nodeFrom->find(idTo) {
    | Some(nodeTo) => findAllPathsBetween_(nodeFrom, nodeTo, [])
    | None => []
    }
  | None => []
  }

let isSpecial = (node: node) => node.id == "start" || node.id == "end"

let rec findAllPathsBetween2_: (node, node, (path, bool)) => array<path> = (
  nodeFrom,
  nodeTo,
  (path, usedDouble),
) =>
  if nodeFrom == nodeTo {
    [path |> Vector.append(nodeFrom.id)]
  } else {
    let pathAndThis = path |> Vector.append(nodeFrom.id)
    nodeFrom.connections
    ->Array2.filter(node =>
      node.isBig || !(path->Utils.vectorHas(node.id)) || (!usedDouble && !(node->isSpecial))
    )
    ->Utils.flatMap(node =>
      findAllPathsBetween2_(
        node,
        nodeTo,
        (pathAndThis, usedDouble || (path->Utils.vectorHas(node.id) && !node.isBig)),
      )
    )
  }

let findAllPathsBetween2: (node, string, string) => array<path> = (graph, idFrom, idTo) =>
  switch graph->find(idFrom) {
  | Some(nodeFrom) =>
    switch nodeFrom->find(idTo) {
    | Some(nodeTo) => findAllPathsBetween2_(nodeFrom, nodeTo, ([], false))
    | None => []
    }
  | None => []
  }
