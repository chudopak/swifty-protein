//
//  ProteinScene.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/14/22.
//

import UIKit
import SceneKit

class ProteinScene: SCNScene, SCNNodeRendererDelegate {
    
    private var atoms = [SCNNode]()
    private var activeConections = [Int: [Int]]()
    
    init(proteinData: ProteinData) {
        super.init()
        atoms.reserveCapacity(proteinData.elements.count)
        var elements = proteinData.elements
        elements.sort(by: { $0.index < $1.index })
        
        configureAtoms(elements: elements)
        configureConections(elements: elements)
        let camera = createCamera(elements: elements)
        rootNode.addChildNode(camera)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAtoms(elements: [ElementData]) {
        for element in elements {
            let atom = createAtom(
                name: element.name,
                radius: ProteinSizes.Molecule.sphereRadius,
                coordinates: element.coordinates
            )
            atoms.append(atom)
            rootNode.addChildNode(atom)
        }
    }
    
    private func createAtom(
        name: String,
        radius: CGFloat,
        coordinates: Coordinates
    ) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.firstMaterial?.diffuse.contents = CPKColors.getColor(string: name)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(coordinates.x, coordinates.y, coordinates.z)
        sphere.name = name
        return sphereNode
    }
    
    private func configureConections(elements: [ElementData]) {
        for i in 0..<elements.count {
            for index in elements[i].conections
            where elements.count > index - 1
                    && !isConnectionExists(
                        atom1: elements[i].index,
                        atom2: elements[index - 1].index
                    ) {
                let cylinder = createConnection(parentAtom: atoms[i], connectAtom: atoms[index - 1])
                if activeConections[elements[i].index] != nil {
                    activeConections[elements[i].index]?.append(index)
                } else {
                    activeConections[elements[i].index] = [index]
                }
                rootNode.addChildNode(cylinder)
            }
        }
    }
    
    private func isConnectionExists(atom1: Int, atom2: Int) -> Bool {
        guard let conections = activeConections[atom1]
        else {
            return false
        }
        for elem in conections where elem == atom2 {
            return true
        }
        return false
    }
    
    private func createConnection(parentAtom: SCNNode, connectAtom: SCNNode) -> SCNNode {
        let height = getCylinderHeight(v1: parentAtom.position, v2: connectAtom.position)
        let position = getCylinderCenter(v1: parentAtom.position, v2: connectAtom.position)
        
        let cylinder = SCNCylinder(
            radius: ProteinSizes.Molecule.cylinderRadius,
            height: CGFloat(height)
        )
        cylinder.firstMaterial?.diffuse.contents = UIColor.white
        
        let nodeWithCylinder = SCNNode(geometry: cylinder)
        nodeWithCylinder.position = position
        nodeWithCylinder.look(
            at: parentAtom.position,
            up: rootNode.worldUp,
            localFront: nodeWithCylinder.worldUp
        )
        return nodeWithCylinder
    }
    
    private func getCylinderHeight(v1: SCNVector3, v2: SCNVector3) -> Double {
        let xd = v2.x - v1.x
        let yd = v2.y - v1.y
        let zd = v2.z - v1.z
        let distance = Double(sqrt(xd * xd + yd * yd + zd * zd))
        return abs(distance)
    }
    
    private func getCylinderCenter(v1: SCNVector3, v2: SCNVector3) -> SCNVector3 {
        let x = (v1.x + v2.x) / 2
        let y = (v1.y + v2.y) / 2
        let z = (v1.z + v2.z) / 2
        return SCNVector3(x, y, z)
    }
    
    private func createCamera(elements: [ElementData]) -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.projectionDirection = .horizontal
        let coordinates = countCameraCoordinates(
            elements: elements,
            cameraAngleDegre: cameraNode.camera!.fieldOfView / 2
        )
        cameraNode.position = SCNVector3(coordinates.x, coordinates.y, coordinates.z)
        cameraNode.camera?.zFar = coordinates.z + ProteinSizes.Camera.farDepthLimitOffsetFromStartHeight
        return cameraNode
    }
    
    private func countCameraCoordinates(elements: [ElementData], cameraAngleDegre: CGFloat) -> Coordinates {
        let extremeCoordinates = moleculeExtremeCoordinates(elements: elements)
        let cathetus = getBiggestDistanceFromCenterToSideOfXYRectangle(extremeCoordinates: extremeCoordinates)
        let zHeight = cathetus / Double(tan(cameraAngleDegre * .pi / 180)) + extremeCoordinates.zMax
        guard zHeight > ProteinSizes.Camera.minStartHeight
        else {
            return Coordinates(x: 0, y: 0, z: ProteinSizes.Camera.minStartHeight)
        }
        return Coordinates(x: 0, y: 0, z: zHeight)
    }
    
    private func moleculeExtremeCoordinates(elements: [ElementData]) -> MoleculeExtremeCoordinates {
        var extremeCoordinates = MoleculeExtremeCoordinates()
        for elem in elements {
            extremeCoordinates.xMin = elem.coordinates.x < extremeCoordinates.xMin
                ? elem.coordinates.x
                : extremeCoordinates.xMin
            extremeCoordinates.xMax = elem.coordinates.x > extremeCoordinates.xMax
                ? elem.coordinates.x
                : extremeCoordinates.xMax
            extremeCoordinates.yMin = elem.coordinates.y < extremeCoordinates.yMin
                ? elem.coordinates.y
                : extremeCoordinates.yMin
            extremeCoordinates.yMax = elem.coordinates.y > extremeCoordinates.yMax
                ? elem.coordinates.y
                : extremeCoordinates.yMax
            extremeCoordinates.zMin = elem.coordinates.z < extremeCoordinates.zMin
                ? elem.coordinates.z
                : extremeCoordinates.zMin
            extremeCoordinates.zMax = elem.coordinates.z > extremeCoordinates.zMax
                ? elem.coordinates.z
                : extremeCoordinates.zMax
        }
        return extremeCoordinates
    }
    
    private func getBiggestDistanceFromCenterToSideOfXYRectangle(extremeCoordinates: MoleculeExtremeCoordinates) -> Double {
        let xMax = max(abs(extremeCoordinates.xMax), abs(extremeCoordinates.xMin))
        let yMax = max(abs(extremeCoordinates.yMax), abs(extremeCoordinates.yMin))
        return xMax < yMax
                    ? yMax
                    : xMax
    }
}
