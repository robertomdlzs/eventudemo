"use client"

import type React from "react"

import { Suspense, useState, useEffect } from "react"
import { getAdminRoles, createAdminRole, updateAdminRole, deleteAdminRole } from "@/app/admin/actions"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { MoreHorizontal, PlusCircle, Edit, Trash2, Plus, X } from "lucide-react"
import { useToast } from "@/hooks/use-toast"
import { Badge } from "@/components/ui/badge"
import type { AdminRole } from "@/lib/types"

interface RoleFormValues {
  name: string
  description?: string
  permissions: string[]
}

interface CreateRoleDialogProps {
  onCreate: (data: Omit<AdminRole, "id" | "createdAt">) => void
}

function CreateRoleDialog({ onCreate }: CreateRoleDialogProps) {
  const [open, setOpen] = useState(false)
  const [formData, setFormData] = useState<RoleFormValues>({
    name: "",
    description: "",
    permissions: [],
  })
  const [newPermission, setNewPermission] = useState("")

  const addPermission = () => {
    if (newPermission.trim() && !formData.permissions.includes(newPermission.trim())) {
      setFormData((prev) => ({
        ...prev,
        permissions: [...prev.permissions, newPermission.trim()],
      }))
      setNewPermission("")
    }
  }

  const removePermission = (permToRemove: string) => {
    setFormData((prev) => ({
      ...prev,
      permissions: prev.permissions.filter((perm) => perm !== permToRemove),
    }))
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onCreate(formData)
    setOpen(false)
    setFormData({ name: "", description: "", permissions: [] }) // Reset form
    setNewPermission("")
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="bg-gradient-to-r from-pink-500 to-purple-600">
          <PlusCircle className="mr-2 h-4 w-4" />
          Nuevo Rol
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Crear Nuevo Rol</DialogTitle>
          <DialogDescription>Define un nuevo rol de usuario y sus permisos.</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="name" className="text-right">
              Nombre
            </Label>
            <Input
              id="name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="col-span-3"
              required
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="description" className="text-right">
              Descripción
            </Label>
            <Textarea
              id="description"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="newPermission" className="text-right">
              Permisos
            </Label>
            <div className="col-span-3 flex gap-2">
              <Input
                id="newPermission"
                value={newPermission}
                onChange={(e) => setNewPermission(e.target.value)}
                placeholder="Ej: manage_users"
                onKeyPress={(e) => e.key === "Enter" && (e.preventDefault(), addPermission())}
              />
              <Button type="button" onClick={addPermission} size="icon">
                <Plus className="h-4 w-4" />
              </Button>
            </div>
          </div>
          {formData.permissions.length > 0 && (
            <div className="col-span-4 col-start-2 flex flex-wrap gap-2">
              {formData.permissions.map((perm) => (
                <Badge key={perm} variant="secondary">
                  {perm}
                  <button
                    type="button"
                    onClick={() => removePermission(perm)}
                    className="ml-1 text-red-500 hover:text-red-700"
                  >
                    <X className="h-3 w-3" />
                  </button>
                </Badge>
              ))}
            </div>
          )}
          <DialogFooter>
            <Button type="submit">Crear Rol</Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

interface EditRoleDialogProps {
  role: AdminRole
  onUpdate: (id: string, data: Partial<Omit<AdminRole, "id" | "createdAt">>) => void
}

function EditRoleDialog({ role, onUpdate }: EditRoleDialogProps) {
  const [open, setOpen] = useState(false)
  const [formData, setFormData] = useState<RoleFormValues>({
    name: role.name,
    description: role.description,
    permissions: role.permissions,
  })
  const [newPermission, setNewPermission] = useState("")

  const addPermission = () => {
    if (newPermission.trim() && !formData.permissions.includes(newPermission.trim())) {
      setFormData((prev) => ({
        ...prev,
        permissions: [...prev.permissions, newPermission.trim()],
      }))
      setNewPermission("")
    }
  }

  const removePermission = (permToRemove: string) => {
    setFormData((prev) => ({
      ...prev,
      permissions: prev.permissions.filter((perm) => perm !== permToRemove),
    }))
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onUpdate(role.id, formData)
    setOpen(false)
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
          <Edit className="mr-2 h-4 w-4" />
          Editar
        </DropdownMenuItem>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Editar Rol</DialogTitle>
          <DialogDescription>Modifica los detalles del rol seleccionado.</DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="name" className="text-right">
              Nombre
            </Label>
            <Input
              id="name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="col-span-3"
              required
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="description" className="text-right">
              Descripción
            </Label>
            <Textarea
              id="description"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="newPermission" className="text-right">
              Permisos
            </Label>
            <div className="col-span-3 flex gap-2">
              <Input
                id="newPermission"
                value={newPermission}
                onChange={(e) => setNewPermission(e.target.value)}
                placeholder="Ej: manage_users"
                onKeyPress={(e) => e.key === "Enter" && (e.preventDefault(), addPermission())}
              />
              <Button type="button" onClick={addPermission} size="icon">
                <Plus className="h-4 w-4" />
              </Button>
            </div>
          </div>
          {formData.permissions.length > 0 && (
            <div className="col-span-4 col-start-2 flex flex-wrap gap-2">
              {formData.permissions.map((perm) => (
                <Badge key={perm} variant="secondary">
                  {perm}
                  <button
                    type="button"
                    onClick={() => removePermission(perm)}
                    className="ml-1 text-red-500 hover:text-red-700"
                  >
                    <X className="h-3 w-3" />
                  </button>
                </Badge>
              ))}
            </div>
          )}
          <DialogFooter>
            <Button type="submit">Guardar Cambios</Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  )
}

export default function AdminRolesClientPage() {
  const [roles, setRoles] = useState<AdminRole[]>([])
  const [loading, setLoading] = useState(true)
  const { toast } = useToast()

  const fetchRoles = async () => {
    setLoading(true)
    try {
      const fetchedRoles = await getAdminRoles()
      setRoles(fetchedRoles)
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "No se pudieron cargar los roles.",
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchRoles()
  }, [])

  const handleCreate = async (data: Omit<AdminRole, "id" | "createdAt">) => {
    try {
      await createAdminRole(data)
      toast({
        title: "Rol Creado",
        description: `El rol "${data.name}" ha sido creado exitosamente.`,
      })
      fetchRoles()
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "Hubo un problema al crear el rol.",
        variant: "destructive",
      })
    }
  }

  const handleUpdate = async (id: string, data: Partial<Omit<AdminRole, "id" | "createdAt">>) => {
    try {
      const updateData = {
        name: data.name || "",
        description: data.description || "",
        permissions: data.permissions || []
      }
      await updateAdminRole(id, updateData)
      toast({
        title: "Rol Actualizado",
        description: `El rol "${data.name}" ha sido actualizado exitosamente.`,
      })
      fetchRoles()
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "Hubo un problema al actualizar el rol.",
        variant: "destructive",
      })
    }
  }

  const handleDelete = async (id: string) => {
    try {
      await deleteAdminRole(id)
      toast({
        title: "Rol Eliminado",
        description: "El rol ha sido eliminado exitosamente.",
      })
      fetchRoles()
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "Hubo un problema al eliminar el rol.",
        variant: "destructive",
      })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold bg-gradient-to-r from-slate-900 to-slate-600 bg-clip-text text-transparent">
          Gestión de Roles
        </h1>
        <CreateRoleDialog onCreate={handleCreate} />
      </div>

      <Card className="border-0 shadow-lg bg-gradient-to-br from-blue-50 to-blue-100">
        <CardHeader className="bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-t-lg">
          <CardTitle>Listado de Roles</CardTitle>
        </CardHeader>
        <CardContent className="p-6">
          <Suspense fallback={<div>Cargando roles...</div>}>
            {loading ? (
              <div className="text-center py-8 text-gray-500">Cargando roles...</div>
            ) : roles.length === 0 ? (
              <div className="text-center py-8 text-gray-500">No hay roles registrados.</div>
            ) : (
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow className="bg-blue-50 text-blue-800">
                      <TableHead>Nombre</TableHead>
                      <TableHead>Descripción</TableHead>
                      <TableHead>Permisos</TableHead>
                      <TableHead className="text-right">Acciones</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {roles.map((role) => (
                      <TableRow key={role.id}>
                        <TableCell className="font-medium">{role.name}</TableCell>
                        <TableCell className="max-w-[250px] truncate">{role.description}</TableCell>
                        <TableCell>{role.permissions.join(", ")}</TableCell>
                        <TableCell className="text-right">
                          <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                              <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Abrir menú</span>
                                <MoreHorizontal className="h-4 w-4" />
                              </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end">
                              <DropdownMenuLabel>Acciones</DropdownMenuLabel>
                              <EditRoleDialog role={role} onUpdate={handleUpdate} />
                              <DropdownMenuSeparator />
                              <DropdownMenuItem className="text-red-600" onClick={() => handleDelete(role.id)}>
                                <Trash2 className="mr-2 h-4 w-4" />
                                Eliminar
                              </DropdownMenuItem>
                            </DropdownMenuContent>
                          </DropdownMenu>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            )}
          </Suspense>
        </CardContent>
      </Card>
    </div>
  )
}
