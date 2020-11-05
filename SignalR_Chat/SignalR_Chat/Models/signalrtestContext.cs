using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace SignalR_Chat.Models
{
    public partial class signalrtestContext : DbContext
    {
        public signalrtestContext()
        {
        }

        public signalrtestContext(DbContextOptions<signalrtestContext> options)
            : base(options)
        {
        }

        public virtual DbSet<ChatUser> ChatUser { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("workstation id=signalrtest.mssql.somee.com;packet size=4096;user id=ankiimation_SQLLogin_1;pwd=rgv45txxd8;data source=signalrtest.mssql.somee.com;persist security info=False;initial catalog=signalrtest");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ChatUser>(entity =>
            {
                entity.HasKey(e => e.Email)
                    .HasName("PK__ChatUser__AB6E61657BF4B8B7");

                entity.Property(e => e.Email)
                    .HasColumnName("email")
                    .HasMaxLength(320);

                entity.Property(e => e.Avatar).HasColumnName("avatar");

                entity.Property(e => e.ConnectionId).HasColumnName("connectionId");

                entity.Property(e => e.Nickname)
                    .HasColumnName("nickname")
                    .HasMaxLength(50);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
