using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Tsunami : Ability
    {
        public Tsunami()
        {
            Name = "Tsunami";
            FlavorText = "A giant wave crashes followed by series of more waves crashing into you.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
