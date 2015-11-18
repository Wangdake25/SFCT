(** * 前言 *)

(* ###################################################################### *)
(** * 简介 *)

(** 这本电子书是一个关于软件基础 ，可靠软件背后的数学的课程.
    主题包含基本逻辑概念，用计算机辅助定理证明，Coq证明助理（Proof Assistant），
    函数式编程（Functional Programming），操作语义（Operational Semantic），
    霍尔逻辑（Hoare Logic），还有静态类型系统（Static Type System）。
    这个课程的预期受众是从高级本科生到博士与及研究生的读者、
    尽管一定的数学熟练度会有帮助，
    本书没有做任何“读者有逻辑学或编程语言的背景”的假设。

    这个教程的最大创新是，本教程是百分之百形式化，并且机械验证的：
    所有的文字都是字面意义上的，Coq脚本。

    它是用于于一个Coq交互式会话一起阅读的。
    本书的所有细节都完全用Coq形式化了，习题也是被设计于来Coq做出。

    文件被整理为一系列覆盖了一学期内容，环环相扣的核心章节，
    与及一定的包含额外主题的“附录”。
    所有的核心章节都适合高级本科生与及研究生。 *)


(* ###################################################################### *)
(** * 导论 *)

(** 构建可靠的软件很难。现代系统的规模，复杂性，介入构建过程的人数，
    还有置于系统之上的需求的范围，使得构建或多或少正确的软件很难，
    更不用说百分百正确。同一时间，因为信息处理继续融入社会的各个方面，
    程序错误于漏洞的代价越来越严重.

    计算机科学家与及软件工程师对这些挑战，通过设计一系列的改进软件质量的技手法，
    包含对管理软件项目与及编程团队的建议（比如极限编程（Extreme Programming）），
    库（比如模型-试图-控制器（Model-View-Controller），发布-订阅（Publish-Subscribe））
    与及编程语言（面向对象编程（Object Oriented Programmin），
    面向切面编程（Aspect Oriented Programming），函数式编程（Functional Programming））
    的设计哲学，还有用来指定，论证软件属性的数学与工具来应对。

    这门课的重点是最后一个方法。本书教程把五个概念穿插在一起：

    （1）逻辑学里面的基础工具，用于构建并且证明精确的关于程序的假设；

    （2）用证明助理构建严谨的逻辑论据；

    （3）函数式编程思想，同时作为编程方法与及程序跟逻辑学之间的桥梁；

    （4）形式化的用于论证程序属性（一个循环对所有输入都会终止。
         或者一个排序函数或者编译器满足特定规格）的手段；与及

    （5）用类型系统建立一个对于某一个编程语言的所有程序都满足的特性
        （所有类型正确的Java程序不能在运行时被破坏）。

    这五个主题任一个都可以轻易填满一整个课程；
    把它们五个塞在一个课程中很自然地表面很多会被遗留在外。
    但是我们希望读者会认为5个主题互补，与及同时教授五个内容会创建一个使读者
    可以轻松进入任一主题的根基。一些更深的阅读的建议会在 [Postscript] 一章出现*)

(** ** 逻辑学 *)

(** 逻辑学是研究证明--不可被质疑的对真理或者某一特定命题的论证的学科。
    我们对逻辑学在计算机科学中所占的中心地位写了一卷又一卷的书。
    Manna与及Waldinger称之“计算机科学的微积分”，与此同时，Halpern的论文
    _On the Unusual Effectiveness of Logic in Computer Science_ 列出各种不同
    逻辑学对计算机科学提供关键工具，洞察的方法。的确，他们观察到
    “事实上，逻辑学在计算机科学中比在数学中远远的更有效。
    这很值得提起，特别是因为过去100年间，逻辑学发展的动力大部分来自数学”

    特定的说，归纳证明的基础几号在计算机科学中处处可见。
    你肯定以前见过它们，比如说在离散数学或者算法分析中，但是在我们的这个课程
    我们很会对之在你前所未有的深度下进行检测。*)

(** ** 证明助理 *)

(** 逻辑学与计算机科学的交流并不是单方面的：计算机科学也对逻辑学造了重要的奉献。
    其中一个是发展可以作为帮助构造命题/证明的工具软件。
    这些工具分为两个范畴：

       - 提供一键式操作的自动化定理证明器（Automated Theorem Prover）：
         你给它们一个命题，它们返回真，假，或者超时。
         尽管他们的能力被限制到特定的推理中，他们在最近几年大幅成熟，
         并且现在在各种各样的场合都有被用上。自动化定理证明器的例子包括
         SAT，SMT，还有Model Checker。

       - 证明助理是一种会对于构建证明中比较常规的部分自动化，
         并且在更困难的地方依赖于人类的混合式工具。
         常用的证明助理包括Isabelle， Agda， Twelf， ACL2， PVS，与及Coq,还有很多其他的。

    这节课基于Coq，一个在1983年起就在一定数量的研究所与及大学中发展的证明助理。
    Coq提供了一个丰富的用于机械验证形式化论证的环境。Coq的内核是一个很简单的，
    保证只有正确的推论发生的证明检查器。在此内核之上，Coq环境提供了高层的证明开发设施，
    包括强大的，用于半自动化构造证明的策略，与及一个庞大的包含了各种定义，引力的库。

    Coq容许了各种各样的在计算机科学与及数学上的研究的进行。

    - 作为一个对编程语言建模的平台，Coq成为了
      需要对复杂语言定义进行描述，论证的研究员的一个标准工具。
      比方说，Coq被用于检查JavaCard平台的安全性，得到了最高阶通用准则验证。
      再比方说，Coq被用在x86与及LLVM指令集的形式化规范中。

    - 作为一个开发被形式化验证的软件，Coq被用于建造Compcert，
      一个被完全验证并带有优化，并被用于证明精妙的浮点数相关的算法的正确性的C编译器。
      同一时间，Coq也是Certicrypt，一个用于论证密码学算法的安全性的环境的基础。

    - 作为一个现实的依赖类型编程的环境，Coq激发了数不清的创新。 
      举例说，Harvard的Ynot项目在Coq中嵌入了“关系式霍尔推理”（一个霍尔逻辑的扩展）

    - 作为一个高阶逻辑的证明助理，Coq被用于证实一定数量的数学里的重要结果。
      比方说，Coq的包含复杂计算进证明的能力使得Coq可以开发出第一个四色定理的式化证明。
      这个证明以前在数学家之间有争议性，因为它包含了大量的分情况检查。
      在Coq形式化中，包括计算方面的正确性，所有东西都被检查了。
      近年来，Feit-Thompson定理，分辨有限单群的第一个大步被在更大的努力下，
      在Coq内成功形式化了。

   如果你对名字感到好奇，Coq官网声称：“一些法国计算机科学家有用动物命名他们的软件的传统：
   Caml, Elan, Foc, Phox都是这个隐秘的传统的例子。在法国，“Coq”是公鸡，也
   听起来像Calculus of Construction，Coq的基础的首字符。”公鸡同时是法国的国家象征，
   “Coq”也是Thierry Coquand，Coq的早期开发人员的名字的头三个字母。 *)

(** ** 函数式编程 *)

(** 函数式编程既代表一系列的，几乎可以在任何编程语言里面用的惯用法，也代表
    被设计于强调这些术语的编程语言，包括Haskell，OCaml，StandardML，F##，
    Scala，Scheme，Racket，Common Lisp，Erlang，还有Coq。

    函数式编程已经有数十年历史了--实际上，它甚至可以追溯到Church的λ演算，
    这可是发明与1930年代，内时候计算机时代还没开始呢！
    自从90年代初以来函数式编程享受了业界的软件工程师与及语言设计者的兴趣的激增，
    并且在如Jane St. Capital，Microsoft，Facebook，与及Ericsson等公司的高价值的
    系统有关键地位。

    函数式编程的最基础宗旨是，尽可能的，计算应该是纯的，也就是说，
    执行一段代码的效果只有生成结果：计算应该与输入输出，赋值，可变变量，指针重定向等脱离。
    比如说，一个指令式的排序函数接受一个数字列表，重组指针，使得列表被排序，
    一个纯的排序函数会取一个列表，返回一个含有同样数字，但是被排序的新列表。

    用这样的风格编程的最明显的好处是这样做使得程序更容易被明白/进行论证。
    如果在一个数据结构上的所有操作返回新数据结构，并且旧的结构没有被改动，
    我们就不需要担心旧的数据结构会不会在其他地方用到，
    改程序的一部分会不会破坏程序的另一部分的属性。
    在并发式程序中，每一块可改状态都是漏洞的潜在来源，所以这些考虑变得更关键。
    事实上，业界最近对函数式编程的兴趣一大部分来源于在并发下，它的简洁的行为。

    最近人们对函数式编程的兴奋还有另一个，跟第一个原因有关的原因：
    函数式程序经常比指令式程序更容易并行化。
    如果一个计算没有除了生成结果意外的作用，他什么时候被执行就毫不重要。
    类似的，如果一个数据结构从来没有被修改，它可以被随意复制到任何地方。
    的确，位于超大量分布式计算处理器（如Hadoop）的中心，
    并且被Google用于索引整个互联网的MapReduce惯用法就是函数式编程的经典例子。

    对于这个课程来说，函数式编程有另一个重要的地方：
    它充当了逻辑与及计算机科学的桥梁。
    事实上，Coq自身可以被看成微小但是有极大表达能力的函数式编程语言与及
    一系列用于声明/证明定理的工具的集合体。更多的，当我们做更深的检测的时候，
    我们会发现Coq的这两边其实是同一机智的两面（比如，程序则证明）*)

(** ** 程序验证 *)

(** 本书的前三分之一被用于发展逻辑学与及函数式编程的概念框架，
    与及提升用Coq对非平凡构造的建模，论证的熟练度。
    从此之后，我们会续渐地把重心偏移到两个对构建可靠软件（以及硬件）
    有核心重要性的话题上：用于证明特定程序的属性的与及
    用于证明对于一整个编程语言都满足的属性的技巧。

    对于这两个话题，我们要做的第一件事是找出一个用数学对象表示程序的方法，
    与及用函数/关系表示它们的行为，因为我们需要对它们进行精确的描述。
    我们这方面的工具是抽象语法（Abstract Syntax）与及操作语义，
    一个通过写抽象解释器规定程序行为的方法。
    在一开始，我们尽量用“大步（big-step）”的，更简单可读的操作语义，
    之后，我们会转换到一个更细节化的“小步（small-step）”的，
    可以在不终止的程序与及包含更多语言特性（比如并行化）下更有效的风格。

    我们第一个考虑的编程语言是Imp，一个微小但包含了变量，赋值，条件，循环的编程语言。
    我们会学习两张不同的对Imp程序论证的方法。

    第一，我们考虑我们该如何空额手两个Imp程序是等价的-对所有的内存状态，有同样的行为。
    这个等价的观念因此成为了对元程序（操控程序的程序，比如编译器，优化器）的正确性的标准。
    我们也会构建一个简单的优化器，并证明其正确性。

    第二，我们开发一个用于证明Imp程序满足他们行为的形式化规范的方法学。
    我们引入霍尔三元组-Imp程序，跟描述程序开始之前/结束之后所满足的条件-
    前条件，后条件的概念。与及霍尔逻辑，一个专用于方便地对命令式语言进行论证，
    内建了循环不变项（loop-invariant）等概念的“领域特定逻辑”的论证基础。

    这课程的这一部分是打算给读者尝试
    在一系列现实的软件与及硬件的证明工作里面用到的关键概念与及数学工具。*)

(** ** 类型系统 *)

(** 我们的最后一个主要话题，类型系统，一组用于构建对于一个编程语言里面所有程序的属性的工具，
    包含了课程的最后三分之一部分。

    类型系统是最久经考验，也是最流行的轻量级形式化验证手段的例子。
    他们的论证能力很一般-以至于自动检查器可以在编译器，连接器，分析器里面建造，
    然后被不明白类型系统理论的程序员应用。（其他的轻量级形式化方法的例子包括
    硬件及软件的模型检查器，契约检查器，与及运行时属性检查器）。

    这个话题使得这个课程圆满：我们在这一部分研究的语言，simply typed lambda calculus，
    本质上就是Coq自身的内核的一个简化的模型！*)

(* ###################################################################### *)
(** * Practicalities *)

(* ###################################################################### *)
(** ** Chapter Dependencies *)

(** A diagram of the dependencies between chapters and some suggested
    paths through the material can be found in the file [deps.html]. *)

(* ###################################################################### *)
(** ** System Requirements *)

(** Coq runs on Windows, Linux, and OS X.  You will need:

       - A current installation of Coq, available from the Coq home
         page.  Everything should work with version 8.4.

       - An IDE for interacting with Coq.  Currently, there are two
         choices:

           - Proof General is an Emacs-based IDE.  It tends to be
             preferred by users who are already comfortable with
             Emacs.  It requires a separate installation (google
             "Proof General").

           - CoqIDE is a simpler stand-alone IDE.  It is distributed
             with Coq, but on some platforms compiling it involves
             installing additional packages for GUI libraries and
             such. *)

(* ###################################################################### *)
(** ** Exercises *)

(** Each chapter includes numerous exercises.  Each is marked with a
    "star rating," which can be interpreted as follows:

       - One star: easy exercises that underscore points in the text
         and that, for most readers, should take only a minute or two.
         Get in the habit of working these as you reach them.

       - Two stars: straightforward exercises (five or ten minutes).

       - Three stars: exercises requiring a bit of thought (ten
         minutes to half an hour).

       - Four and five stars: more difficult exercises (half an hour
         and up).

    Also, some exercises are marked "advanced", and some are marked
    "optional."  Doing just the non-optional, non-advanced exercises
    should provide good coverage of the core material.  Optional
    exercises provide a bit of extra practice with key concepts and
    introduce secondary themes that may be of interest to some
    readers.  Advanced exercises are for readers who want an extra
    challenge (and, in return, a deeper contact with the material).

    _Please do not post solutions to the exercises in public places_:
    Software Foundations is widely used both for self-study and for
    university courses.  Having solutions easily available makes it
    much less useful for courses, which typically have graded homework
    assignments.  The authors especially request that readers not post
    solutions to the exercises anyplace where they can be found by
    search engines.
*)

(* ###################################################################### *)
(** ** Downloading the Coq Files *)

(** A tar file containing the full sources for the "release version"
    of these notes (as a collection of Coq scripts and HTML files) is
    available here:
<<
        http://www.cis.upenn.edu/~bcpierce/sf   
>>
    If you are using the notes as part of a class, you may be given
    access to a locally extended version of the files, which you
    should use instead of the release version.
*)

(* ###################################################################### *)
(** * Note for Instructors *)

(** If you intend to use these materials in your own course, you will
    undoubtedly find things you'd like to change, improve, or add.
    Your contributions are welcome!

    Please send an email to Benjamin Pierce describing yourself and
    how you would like to use the materials, and including the result
    of doing "htpasswd -s -n NAME", where NAME is your preferred user
    name.  We'll set you up with read/write access to our subversion
    repository and developers' mailing list; in the repository you'll
    find a [README] with further instructions. *)

(* ###################################################################### *)
(** * Translations *)

(** Thanks to the efforts of a team of volunteer translators, _Software 
    Foundations_ can now be enjoyed in Japanese at [http://proofcafe.org/sf]
*)

(** $Date$ *)

