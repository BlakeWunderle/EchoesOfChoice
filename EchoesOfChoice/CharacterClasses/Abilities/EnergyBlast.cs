using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class EnergyBlast : Ability
    {
        public EnergyBlast()
        {
            Name = "Energy Blast";
            FlavorText = "Use a scientific explosion to hit an enemy";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
