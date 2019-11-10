
        .globl main
            main:
                                                                                mov $12, %rax
                push %rax
                mov $3, %rax
                pop %rbx
                sub %rax, %rbx
                mov %rbx, %rax

                push %rax
                mov $2, %rax
                pop %rbx
                imul %rbx, %rax

                push %rax
                mov $2, %rax
                pop %rbx
                add %rbx, %rax

                push %rax
                                mov $5, %rax
                push %rax
                mov $3, %rax
                pop %rbx
                sub %rax, %rbx
                mov %rbx, %rax

                pop %rbx
                xchg %rax, %rbx
                cqo
                idiv %rbx

            ret
         
        