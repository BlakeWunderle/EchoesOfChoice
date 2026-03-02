using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Ghast : BaseFighter
    {
        public Ghast(int level = 16)
        {
            Level = level;
            Health = Stat(250, 290, 7, 10, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(51, 59, 3, 5, 16);
            PhysicalDefense = Stat(32, 38, 2, 4, 16);
            MagicAttack = Stat(18, 24, 1, 2, 16);
            MagicDefense = Stat(22, 28, 1, 3, 16);
            Speed = Stat(28, 34, 2, 3, 16);
            Abilities = new List<Ability>() { new Slam(), new PoisonCloud(), new Rend() };
            CharacterType = "Ghast";
            Mana = Stat(22, 28, 2, 4, 16);
            MaxMana = Mana;
            CritChance = 17;
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
