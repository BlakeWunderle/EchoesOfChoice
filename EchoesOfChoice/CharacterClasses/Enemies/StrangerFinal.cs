using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class StrangerFinal : BaseFighter
    {
        public StrangerFinal(int level = 20)
        {
            Level = level;
            Health = Stat(890, 990, 18, 24, 20);
            MaxHealth = Health;
            PhysicalAttack = Stat(76, 86, 4, 6, 20);
            PhysicalDefense = Stat(52, 60, 3, 5, 20);
            MagicAttack = Stat(83, 93, 5, 7, 20);
            MagicDefense = Stat(52, 60, 3, 5, 20);
            Speed = Stat(49, 55, 3, 5, 20);
            Abilities = new List<Ability>() { new ShadowBlast(), new Siphon(), new DarkVeil(), new Unmake(), new Corruption() };
            CharacterType = "Stranger";
            Mana = Stat(70, 80, 5, 7, 20);
            MaxMana = Mana;
            CritChance = 29;
            CritDamage = 6;
            DodgeChance = 26;
        }

        public StrangerFinal(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new StrangerFinal(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 15);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
