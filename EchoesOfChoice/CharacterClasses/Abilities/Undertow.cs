using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Undertow : Ability
    {
        public Undertow()
        {
            Name = "Undertow";
            FlavorText = "Pulled beneath swirling currents, movement becomes a struggle.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
