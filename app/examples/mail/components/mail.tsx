"use client"

import * as React from "react"
import {
  AlertCircle,
  Archive,
  ArchiveX,
  File,
  Inbox,
  Loader2,
  MessagesSquare,
  Search,
  Send,
  ShoppingCart,
  Trash2,
  Users2,
} from "lucide-react"

import { cn } from "@/lib/utils"
import { Input } from "@/components/ui/input"
import {
  ResizableHandle,
  ResizablePanel,
  ResizablePanelGroup,
} from "@/components/ui/resizable"
import { Separator } from "@/components/ui/separator"
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs"
import { TooltipProvider } from "@/components/ui/tooltip"
import { AccountSwitcher } from "@/app/examples/mail/components/account-switcher"
import { MailDisplay } from "@/app/examples/mail/components/mail-display"
import { MailList } from "@/app/examples/mail/components/mail-list"
import { Nav } from "@/app/examples/mail/components/nav"
import { type Mail } from "@/app/examples/mail/data"
import { useMail } from "@/app/examples/mail/use-mail"
import { supabase } from "@/lib/supabase" // 导入 Supabase 客户端

interface MailProps {
  accounts: {
    label: string
    email: string
    icon: React.ReactNode
  }[]
  defaultLayout: number[] | undefined
  defaultCollapsed?: boolean
  navCollapsedSize: number
}

export function Mail({
  accounts,
  defaultLayout = [20, 32, 48],
  defaultCollapsed = false,
  navCollapsedSize,
}: MailProps) {
  const [isCollapsed, setIsCollapsed] = React.useState(defaultCollapsed)
  const [mail] = useMail()
  const [mails, setMails] = React.useState<Mail[]>([])
  const [folderCounts, setFolderCounts] = React.useState<Record<string, number>>({})
  const [loading, setLoading] = React.useState(true)
  const [searchQuery, setSearchQuery] = React.useState("")
  const [selectedFolder, setSelectedFolder] = React.useState("Inbox")
  
  // 从 Supabase 获取邮件
  React.useEffect(() => {
    async function fetchEmails() {
      setLoading(true)
      try {
        // 获取文件夹 ID
        const { data: folders } = await supabase
          .from('folders')
          .select('id, name, type')
        
        if (!folders || folders.length === 0) {
          console.error("No folders found")
          setLoading(false)
          return
        }
        
        // 找到当前选中的文件夹
        const folderObj = folders.find(f => 
          f.name.toLowerCase() === selectedFolder.toLowerCase() || 
          f.type.toLowerCase() === selectedFolder.toLowerCase()
        )
        
        if (!folderObj) {
          console.error("Selected folder not found:", selectedFolder)
          setLoading(false)
          return
        }
        
        // 获取该文件夹中的邮件
        const { data, error } = await supabase
          .from('emails')
          .select('*')
          .eq('folder_id', folderObj.id)
          .order('received_at', { ascending: false })
        
        if (error) {
          console.error("Error fetching emails:", error)
          return
        }
        
        // 将数据库格式转换为应用格式
        const formattedMails = data.map(email => ({
          id: email.id,
          name: email.from_name,
          email: email.from_email,
          subject: email.subject,
          text: email.body_text,
          date: email.received_at,
          read: email.is_read,
          labels: [], // 标签数据可能需要另外获取
        }))
        
        setMails(formattedMails)
        
        // 获取文件夹计数
        const counts: Record<string, number> = {}
        for (const folder of folders) {
          const { count, error } = await supabase
            .from('emails')
            .select('id', { count: 'exact', head: true })
            .eq('folder_id', folder.id)
          
          if (error) {
            console.error(`Error counting emails in ${folder.name}:`, error)
            continue
          }
          
          counts[folder.name] = count || 0
        }
        
        setFolderCounts(counts)
      } catch (e) {
        console.error("Error fetching data:", e)
      } finally {
        setLoading(false)
      }
    }
    
    fetchEmails()
  }, [selectedFolder])
  
  // 处理搜索功能
  const filteredMails = React.useMemo(() => {
    if (!searchQuery) return mails
    
    return mails.filter(mail => 
      mail.subject?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      mail.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      mail.email?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      mail.text?.toLowerCase().includes(searchQuery.toLowerCase())
    )
  }, [mails, searchQuery])
  
  // 更新邮件阅读状态
  const markAsRead = async (emailId: string) => {
    try {
      const { error } = await supabase
        .from('emails')
        .update({ is_read: true })
        .eq('id', emailId)
      
      if (error) {
        console.error("Error marking email as read:", error)
        return
      }
      
      // 更新本地状态
      setMails(mails.map(m => 
        m.id === emailId ? { ...m, read: true } : m
      ))
    } catch (e) {
      console.error("Error updating email:", e)
    }
  }
  
  const handleFolderClick = (folderTitle: string) => {
    setSelectedFolder(folderTitle)
  }

  const sendEmail = async (to: string, subject: string, html: string) => {
    try {
      const res = await fetch("https://mvqxxtyfzckmxzjcvmmr.functions.supabase.co/send-email", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email: to,
          subject,
          message: html,
        }),
      })
  
      const data = await res.json()
      console.log("✅ Email sent:", data)
      alert("Email sent successfully!")
    } catch (err) {
      console.error("❌ Failed to send email", err)
      alert("Failed to send email. Please try again.")
    }
  }
  

  return (
    <TooltipProvider delayDuration={0}>
      <ResizablePanelGroup
        direction="horizontal"
        onLayout={(sizes: number[]) => {
          document.cookie = `react-resizable-panels:layout:mail=${JSON.stringify(
            sizes
          )}`
        }}
        className="h-full max-h-[800px] items-stretch"
      >
        <ResizablePanel
          defaultSize={defaultLayout[0]}
          collapsedSize={navCollapsedSize}
          collapsible={true}
          minSize={15}
          maxSize={20}
          onCollapse={() => {
            setIsCollapsed(true)
            document.cookie = `react-resizable-panels:collapsed=${JSON.stringify(
              true
            )}`
          }}
          onResize={() => {
            setIsCollapsed(false)
            document.cookie = `react-resizable-panels:collapsed=${JSON.stringify(
              false
            )}`
          }}
          className={cn(
            isCollapsed &&
              "min-w-[50px] transition-all duration-300 ease-in-out"
          )}
        >
          <div
            className={cn(
              "flex h-[52px] items-center justify-center",
              isCollapsed ? "h-[52px]" : "px-2"
            )}
          >
            <AccountSwitcher isCollapsed={isCollapsed} accounts={accounts} />
          </div>
          <Separator />
          <Nav
            isCollapsed={isCollapsed}
            links={[
              {
                title: "Inbox",
                label: folderCounts["Inbox"]?.toString() || "0",
                icon: Inbox,
                variant: selectedFolder === "Inbox" ? "default" : "ghost",
                onClick: () => handleFolderClick("Inbox")
              },
              {
                title: "Drafts",
                label: folderCounts["Drafts"]?.toString() || "0",
                icon: File,
                variant: selectedFolder === "Drafts" ? "default" : "ghost",
                onClick: () => handleFolderClick("Drafts")
              },
              {
                title: "Sent",
                label: folderCounts["Sent"]?.toString() || "",
                icon: Send,
                variant: selectedFolder === "Sent" ? "default" : "ghost",
                onClick: () => handleFolderClick("Sent")
              },
              {
                title: "Trash",
                label: folderCounts["Trash"]?.toString() || "",
                icon: Trash2,
                variant: selectedFolder === "Trash" ? "default" : "ghost",
                onClick: () => handleFolderClick("Trash")
              },
              {
                title: "Archive",
                label: folderCounts["Archive"]?.toString() || "",
                icon: Archive,
                variant: selectedFolder === "Archive" ? "default" : "ghost",
                onClick: () => handleFolderClick("Archive")
              },
            ]}
          />
          <Separator />
          <Nav
            isCollapsed={isCollapsed}
            links={[
              {
                title: "Social",
                label: "972",
                icon: Users2,
                variant: "ghost",
              },
              {
                title: "Updates",
                label: "342",
                icon: AlertCircle,
                variant: "ghost",
              },
              {
                title: "Forums",
                label: "128",
                icon: MessagesSquare,
                variant: "ghost",
              },
              {
                title: "Shopping",
                label: "8",
                icon: ShoppingCart,
                variant: "ghost",
              },
              {
                title: "Promotions",
                label: "21",
                icon: Archive,
                variant: "ghost",
              },
            ]}
          />
        </ResizablePanel>
        <ResizableHandle withHandle />
        <ResizablePanel defaultSize={defaultLayout[1]} minSize={30}>
          <Tabs defaultValue="all">
            <div className="flex items-center px-4 py-2">
              <h1 className="text-xl font-bold">{selectedFolder}</h1>
              <TabsList className="ml-auto">
                <TabsTrigger
                  value="all"
                  className="text-zinc-600 dark:text-zinc-200"
                >
                  All mail
                </TabsTrigger>
                <TabsTrigger
                  value="unread"
                  className="text-zinc-600 dark:text-zinc-200"
                >
                  Unread
                </TabsTrigger>
              </TabsList>
            </div>
            <Separator />
            <div className="bg-background/95 p-4 backdrop-blur supports-[backdrop-filter]:bg-background/60">
              <form>
                <div className="relative">
                  <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
                  <Input 
                    placeholder="Search" 
                    className="pl-8" 
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>
              </form>
            </div>
            <TabsContent value="all" className="m-0">
              {loading ? (
                <div className="flex justify-center items-center py-8">
                  <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
                </div>
              ) : (
                <MailList 
                  items={filteredMails} 
                  onMailSelect={(id) => {
                    if (id && !mails.find(m => m.id === id)?.read) {
                      markAsRead(id)
                    }
                  }}
                />
              )}
            </TabsContent>
            <TabsContent value="unread" className="m-0">
              {loading ? (
                <div className="flex justify-center items-center py-8">
                  <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
                </div>
              ) : (
                <MailList 
                  items={filteredMails.filter(item => !item.read)}
                  onMailSelect={(id) => {
                    if (id) markAsRead(id)
                  }}
                />
              )}
            </TabsContent>
          </Tabs>
        </ResizablePanel>
        <ResizableHandle withHandle />
        <ResizablePanel defaultSize={defaultLayout[2]} minSize={30}>
          <MailDisplay
            mail={filteredMails.find((item) => item.id === mail.selected) || null}
            onSend={sendEmail}
          />
        </ResizablePanel>
      </ResizablePanelGroup>
    </TooltipProvider>
  )
}

