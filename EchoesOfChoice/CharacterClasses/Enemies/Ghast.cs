using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Ghast : BaseFighter
    {
        public Ghast(int level = 14)
        {
            Level = level;
            Health = Stat(240, 270, 7, 10, 14);
            MaxHealth = Health;
            PhysicalAttack = Stat(44, 52, 3, 5, 14);
            PhysicalDefense = Stat(26, 32, 2, 3, 14);
            MagicAttack = Stat(16, 20, 1, 2, 14);
            MagicDefense = Stat(18, 22, 1, 2, 14);
            Speed = Stat(24, 30, 1, 3, 14);
            Abilities = new List<Ability>() { new Slam(), new PoisonCloud(), new Rend() };
            CharacterType = "Ghast";
            Mana = Stat(18, 24, 2, 4, 14);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 4;
            DodgeChance = 8;
        }

        public Ghast(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Ghast(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
